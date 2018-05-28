package org.seckill.dao.cache;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.seckill.dao.SeckillDao;
import org.seckill.entity.Seckill;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

/**
 * Created by LW on 2018/5/25.
 */

@RunWith(SpringJUnit4ClassRunner.class) // 在junit启动时加载springIOC容器
@ContextConfiguration({"classpath:spring/spring-dao.xml"}) // 告诉junit spring配置文件的工程位置
public class RedisDaoTest {

    private Logger logger = LoggerFactory.getLogger(this.getClass());

    private long testId = 1001;

    @Autowired
    private RedisDao redisDao;

    @Autowired
    private SeckillDao seckillDao;

    /**
     * 全局测试：get/put
     * 测试 RedisDao 对 Seckill 对象的 序列化 与 反序列化 以及 Redis的 缓存
     * <p>
     * 其中 RedisDao redisDao 负责 Redis 缓存操作
     * SeckillDao seckillDao 负责 在 缓存为空时 从数据库 获取 Seckill对象 然后放到 缓存中
     *
     * @throws Exception
     */
    @Test
    public void testSeckillRedis() throws Exception {

        Seckill seckill = redisDao.getSeckill(testId);
        if (seckill == null) { // 第一次缓存为空 从数据库中获取

            // 从数据库中获取
            seckill = seckillDao.queryById(testId);

            if (seckill != null) { // 从数据库中获取到后 更新到缓存中
                String result = redisDao.putSeckill(seckill);
                logger.info("cache result: " + result);

                seckill = redisDao.getSeckill(testId);
                logger.info("seckill:" + seckill);
            } else {
                logger.info("can not get seckill from db");
            }
        } else { // 缓存中取到 直接打印
            logger.info("seckill:" + seckill);
        }
    }
}