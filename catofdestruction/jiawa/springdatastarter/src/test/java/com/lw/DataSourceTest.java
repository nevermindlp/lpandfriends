package com.lw;

import org.junit.After;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.DriverManagerDataSource;

/**
 * Created by LW on 2018/6/26.
 */
public class DataSourceTest {

    /**
     * 应用程序上下文
     */
    private ApplicationContext context = null;

    /**
     * 通过Junit 中的 @Before 注解 在setup方法中 初始化 ApplicationContext
     */
    @Before
    public void setup() {
        context = new ClassPathXmlApplicationContext("beans.xml");
        System.out.println("setup");
    }

    /**
     * 测试完成后销毁资源
     */
    @After
    public void tearDown() {
        context = null;
        System.out.println("tearDown");
    }

    /**
     * 通过上下文 的 getBean方法 拿到Bean对象（传入id）
     */
    @Test
    public void testDataSource() {
        DriverManagerDataSource dataSource =
                (DriverManagerDataSource) context.getBean("dataSource");
        Assert.assertNotNull(dataSource);
        System.out.println("testDataSource");
    }

    @Test
    public void testJdbcTemplate() {
        JdbcTemplate jdbcTemplate=
                (JdbcTemplate) context.getBean("jdbcTemplate");
        Assert.assertNotNull(jdbcTemplate);
        System.out.println("testJdbcTemplate");
    }
}
