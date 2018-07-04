package com.lw.repository;

import com.lw.domain.Employee;
import com.lw.domain.EmployeeMultiKeysClass;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * Created by LW on 2018/6/28.
 */
public class EmplyeeJpaRepositoryTest {


    /**
     * 应用程序上下文
     */
    private ApplicationContext context = null;
    private EmplyeeJpaRepository emplyeeJpaRepository = null;

    /**
     * 通过Junit 中的 @Before 注解 在setup方法中 初始化 ApplicationContext
     */
    @Before
    public void setup() {
        context = new ClassPathXmlApplicationContext("beans-new.xml");
        emplyeeJpaRepository = context.getBean(EmplyeeJpaRepository.class);
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
    public void testFind() {
        EmployeeMultiKeysClass multiKeysClass = new EmployeeMultiKeysClass();
        multiKeysClass.setId(1);
        multiKeysClass.setName("employee1");

        Employee employee = emplyeeJpaRepository.findOne(multiKeysClass);
        System.out.println(employee);

        System.out.println("====>" + emplyeeJpaRepository.exists(multiKeysClass));
//        System.out.println("====>" + emplyeeJpaRepository.exists(10000));
//        System.out.println("====>" + emplyeeJpaRepository.exists(10));
    }
}