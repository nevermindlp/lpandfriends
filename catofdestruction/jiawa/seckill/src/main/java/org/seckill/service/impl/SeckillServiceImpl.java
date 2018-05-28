package org.seckill.service.impl;

import org.seckill.dao.SeckillDao;
import org.seckill.dao.SuccessKilledDao;
import org.seckill.dao.cache.RedisDao;
import org.seckill.dto.Exposer;
import org.seckill.dto.SeckillExecution;
import org.seckill.entity.Seckill;
import org.seckill.entity.SuccessKilled;
import org.seckill.enums.SeckillStateEnum;
import org.seckill.exception.RepeatKillException;
import org.seckill.exception.SeckillCloseException;
import org.seckill.exception.SeckillException;
import org.seckill.service.SeckillService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.DigestUtils;

import java.util.Date;
import java.util.List;

/**
 * Created by LW on 2018/5/17.
 */
//@Component @Service @Dao @Controller
@Service
public class SeckillServiceImpl implements SeckillService {

    private Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    private RedisDao redisDao;
    // 注入Service依赖（mybatis通过mapper的方式将dao实现并初始化好 放入到了spring容器中 需要获取dao实例注入到Service下面）
//    @Autowired spring提供的注解 @Resource @Inject j2ee规范提供的注解
    @Autowired // 会在spring容器中查找该类型的dao实例（通过mybatis mapper实现）并注入 不需要new dao
    private SeckillDao seckillDao;
    @Autowired
    private SuccessKilledDao successKilledDao;
    // md5盐值字符串，用于混淆md5
    private final String salt = "as;djfk1@#!@KLDFSADF!@#!@#!@";

    @Override
    public List<Seckill> getSeckillList() {
        return seckillDao.queryAll(0, 4);
    }

    @Override
    public Seckill getById(long seckillId) {
        return seckillDao.queryById(seckillId);
    }

    @Override
    public Exposer exportSeckillUrl(long seckillId) {

        /**
         * 优化点：后端缓存优化
         * 一致性维护 建立在超时 jedis setex 的基础上（理由：因为秒杀业务的产品 一般情况下 建立好秒杀单就不允许修改了，只能废弃后重新新建）
         *
         * 秒杀产品访问量较高
         * 通过Redis 缓存秒杀对象，降低了数据库的访问量
         *
         * 当然，在线上环境 Redis 并非是简单的 Singleton 环境，通常是 一个集群（而不是一台机器）
         * 而且 访问逻辑的 一致性维护  也不会这么简单   通过超时维护
         *
         */
        // 1. 访问redis 获取对象
        Seckill seckill = redisDao.getSeckill(seckillId);
        if (seckill == null) {
            // 2. 访问数据库 获取对象
            seckill = this.getById(seckillId);
            if (seckill == null) {
                return new Exposer(false, seckillId);
            }
            // 3. 更新缓存
            String result = redisDao.putSeckill(seckill);
            logger.info("exportSeckillUrl put cache successfully:  " + result + seckill);
        } else {
            logger.info("exportSeckillUrl get cache objet successfully:  " + seckill);
        }

        Date startTime = seckill.getStartTime();
        Date endTime = seckill.getEndTime();
        Date nowTime = new Date();
        if (nowTime.getTime() < startTime.getTime()
                || nowTime.getTime() > endTime.getTime()) {
            return new Exposer(false, seckillId, nowTime.getTime(), startTime.getTime(), endTime.getTime());
        }
        String md5 = this.getMD5(seckillId);
        return new Exposer(true, md5, seckillId);
    }

    private String getMD5(long seckillId) {
        String base = seckillId + "/" + salt;
        return DigestUtils.md5DigestAsHex(base.getBytes());
    }

    @Override
    @Transactional
    /**
     *
     * （声明式事务原理：利用aop技术 在方法头尾添加 begin commit/rollback）
     *
     * 使用注解控制事务方法的优点：（不推荐使用advice aop 而是是使用 @Transactional 注解）
     * 1. 开发团队达成一致约定，明确标注事务方法的编程风格
     * 2. 保证事务方法的执行时间尽可能短，尽量不要穿插其他网络操作 RPC/HTTP请求 如：Redis mc
     * 如果还是需要操作网络 缓存 可以将其剥离到 事务方法外部，再做一个更上层的方法 先完成操作后将数据 传入到下层 数据库事务操作方法
     * （因为事务开启后 因为有写入操作会产生锁定 为了降低update等的 锁定操作的时间）
     * 3. 不是所有的方法都需要事务，如只有一条修改操作、只读操作都不需要事务控制，若用advice aop进行全局配置会不灵活
     *
     */
    public SeckillExecution executeSeckill(long seckillId, long userPhone, String md5)
            throws SeckillException, RepeatKillException, SeckillCloseException {
        if (md5 == null || !md5.equals(getMD5(seckillId))) {
            throw new SeckillException("seckill data rewrite");
        }
        /**
         * 执行顺序 初步优化：
         * spring 事务保证：更新库存 和 插入购买记录 有一个执行失败 都会进行回滚
         *
         * 因为
         * 需要锁的 语句实际上是 update 热点商品（行级锁），insert 不会进行枷锁 可以并发插入
         *
         * 所以
         * 先insert 后update 会减少一次加锁串行时（insert） 的网络延迟+gc 时间
         * 而 先update 后insert 会增加 网络延迟和gc的时间
         *
         */
        // 秒杀业务逻辑：减库存 + 记录购买行为
        Date killDate = new Date();
        try {
            // 记录购买行为 insert ignore 通过逐渐冲突 不会报错 而是返回0 即重复秒杀
            int insertCount = successKilledDao.insertSuccessKilled(seckillId, userPhone);
            // 联合主键唯一：seckillId, userPhone
            if (insertCount <= 0) {
                // 重复秒杀
                throw new RepeatKillException("seckill repeated");
            } else {
                // 减库存（热点商品竞争 需要拿到mysql的行级锁）
                int updateCount = seckillDao.reduceNumber(seckillId, killDate);
                if (updateCount <= 0) {
                    // 没有更新记录，秒杀结束（时间到了 或者 没有库存了）===> rollback
                    throw new SeckillCloseException("seckill is closed");
                } else {
                    // 秒杀成功 ===> commit
                    SuccessKilled successKilled = successKilledDao.queryByIdWithSeckill(seckillId, userPhone);
                    return new SeckillExecution(seckillId, SeckillStateEnum.SUCCESS, successKilled);
                }
            }
        } catch (SeckillCloseException e1) {
            throw e1;
        } catch (RepeatKillException e2) {
            throw e2;
        } catch (Exception e) {
            // 除了已知异常 还可能会出现 Dao可能出现插入超时 数据库连接池断了等异常
            // 把所有编译期异常 转换成运行期异常（业务异常）
            // spring 声明式事务会做rollback 为了防止 减库存操作 和 记录购买行为操作 没有同时执行
            logger.error(e.getMessage(), e);
            throw new SeckillException("seckill inner error:" + e.getMessage());
        }
    }
}