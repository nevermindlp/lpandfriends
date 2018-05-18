package org.seckill.dao;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.seckill.entity.Seckill;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.annotation.Resource;
import java.util.Date;
import java.util.List;

/**
 * Created by LW on 2018/5/16.
 */

/**
 *
 * 首先要配置spring和junit整合，目的是为了junit启动时 加载springIOC容器
 * spring-test, junit
 * RunWith接口是Runner下面的 是junit依赖 可以传入 SpringJUnit4ClassRunner 来在junit启动时加载springIOC容器
 * ContextConfiguration 注解 告诉junit spring配置文件的位置 自动在加载spring容器时应用 spring-dao.xml 中的配置
 *
 *
 * 如果直接写方法 可能需要SeckillDao 实现类的依赖 而SeckillDao 的实现类是通过mybatis 自动做的
 * 同时通过与spring整合 将Dao的实现类 注入到了 spring容器中
 *
 */
@RunWith(SpringJUnit4ClassRunner.class) // 在junit启动时加载springIOC容器
@ContextConfiguration({"classpath:spring/spring-dao.xml"}) // 告诉junit spring配置文件的工程位置
public class SeckillDaoTest {

    // 注入Dao实现类依赖 以完成SeckillDao 测试
    // SeckillDao的实现类已经 初始化好 并放在了spring容器中 所以可以直接使用
    // 使用 Resource 注解  在spring容器中查找SeckillDao实现类 并注入到单元测试类中
    @Resource
    private SeckillDao seckillDao;

    @Test
    public void reduceNumber() throws Exception {
        /*
        SpringManagedTransaction - JDBC Connection [com.mchange.v2.c3p0.impl.NewProxyConnection@3b4ef7]
         will not be managed by Spring
        ==>  Preparing: UPDATE seckill SET number = number - 1
        WHERE seckill_id = ? AND start_time <= ? AND end_time >= ? AND number > 0;
        ==> Parameters: 1000(Long), 2018-05-16 15:40:15.893(Timestamp), 2018-05-16 15:40:15.893(Timestamp)
        <==    Updates: 0
        */
        long id = 1000;
        Date killTime = new Date();
        int updateCount = seckillDao.reduceNumber(id, killTime);
        System.out.println("updateCount= " + updateCount);
    }

    @Test
    public void queryById() throws Exception {
        /*
        SpringManagedTransaction - JDBC Connection [com.mchange.v2.c3p0.impl.NewProxyConnection@52350abb]
        will not be managed by Spring
        ==>  Preparing: SELECT seckill_id, name, number, start_time, end_time, create_time FROM seckill
        WHERE seckill_id = ?
        ==> Parameters: 1000(Long)
        <==      Total: 1
        org.mybatis.spring.SqlSessionUtils - Closing non transactional SqlSession
        [org.apache.ibatis.session.defaults.DefaultSqlSession@560cbf1a]
         */
        long id = 1000;
        Seckill seckill = seckillDao.queryById(id);
        System.out.println(seckill.getName());
        System.out.println(seckill.toString());
    }

    @Test
    public void queryAll() throws Exception {
        /*
        * Caused by: org.apache.ibatis.binding.BindingException:
        * Parameter 'offset' not found. Available parameters are [0, 1, param1, param2]
        *
        * List<Seckill> queryAll(int offset, int limit); ->  queryAll(arg0, arg1);
        * Java 没有保存形参的记录  多个参数的情况需要告诉mybatis 那个位置参数叫什么名字
        * 这样在 xml中 sql语句使用 #{}的方式获取 参数时 才能找到具体值 使用Mybatis提供的注解@Param
        *
        * */

        /*
        SpringManagedTransaction - JDBC Connection [com.mchange.v2.c3p0.impl.NewProxyConnection@3a7704c]
         will not be managed by Spring
        ==>  Preparing: SELECT seckill_id, name, number, start_time, end_time, create_time FROM seckill
        ORDER BY create_time DESC limit ?, ?
        ==> Parameters: 0(Integer), 100(Integer)
        <==      Total: 4
        */
        List<Seckill> seckills = seckillDao.queryAll(0, 100);
        seckills.stream().forEach(seckill -> {
            System.out.println(seckill.getName());
            System.out.println(seckill.toString());
        });
    }

}