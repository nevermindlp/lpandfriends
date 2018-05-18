package org.seckill.dao;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.seckill.entity.SuccessKilled;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.annotation.Resource;

/**
 * Created by LW on 2018/5/16.
 */

@RunWith(SpringJUnit4ClassRunner.class) // 在junit启动时加载springIOC容器
@ContextConfiguration({"classpath:spring/spring-dao.xml"}) // 告诉junit spring配置文件的工程位置
public class SuccessKilledDaoTest {

    @Resource
    private SuccessKilledDao successKilledDao;

    @Test
    public void insertSuccessKilled() throws Exception {


        /*
        * 第一次 insertCount= 1
        * 第二次 insertCount= 0
        *
        * 因为不允许重复秒杀 即不允许重复插入购买成功的记录 通过联合主键 唯一保证
        *
        * 如果sql insert ignore into 去掉 ignore 会主键冲突 异常报错
        * com.mysql.jdbc.exceptions.jdbc4.MySQLIntegrityConstraintViolationException:
        * Duplicate entry '1000-13502181181' for key 'PRIMARY'
        *
        * */
        long id = 1001;
        long userPhone = 13502181181L;
        int insertCount = successKilledDao.insertSuccessKilled(id, userPhone);
        System.out.println("insertCount= " + insertCount);
    }

    @Test
    public void queryByIdWithSeckill() throws Exception {

        /*SpringManagedTransaction - JDBC Connection [com.mchange.v2.c3p0.impl.NewProxyConnection@23c388c2]
         will not be managed by Spring
        ==>  Preparing: SELECT sk.seckill_id, sk.user_phone, sk.create_time, sk.state,
         s.seckill_id "seckill.seckill_id", s.name "seckill.name", s.number "seckill.number",
         s.start_time "seckill.start_time", s.end_time "seckill.end_time", s.create_time "seckill.create_time"
        FROM success_killed AS sk
        INNER JOIN
        seckill AS s
        ON sk.seckill_id = s.seckill_id
        WHERE sk.seckill_id=? AND sk.user_phone=?
        ==> Parameters: 1000(Long), 13502181181(Long)
        <==      Total: 1
                */
        long id = 1001;
        long userPhone = 13502181181L;
        SuccessKilled successKilled = successKilledDao.queryByIdWithSeckill(id, userPhone);
        System.out.println(successKilled.toString());
        System.out.println(successKilled.getSeckill());
    }
}