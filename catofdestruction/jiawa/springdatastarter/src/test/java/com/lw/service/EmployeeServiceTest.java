package com.lw.service;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * Created by LW on 2018/6/28.
 */
public class EmployeeServiceTest {

    /**
     * 应用程序上下文
     */
    private ApplicationContext context = null;
    private EmployeeService employeeService = null;

    /**
     * 通过Junit 中的 @Before 注解 在setup方法中 初始化 ApplicationContext
     */
    @Before
    public void setup() {
        context = new ClassPathXmlApplicationContext("beans-new.xml");
        employeeService = context.getBean(EmployeeService.class);
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

    @Test
    public void updateAgeById() throws Exception {
        employeeService.updateAgeById(3, 30);
    }

    @Test
    public void updateNameById() throws Exception {
        employeeService.updateNameById(3, "laowang");
    }

    @Test
    public void removeById() throws Exception {
        employeeService.removeById(7);
    }
}