package com.lw.repository;

import com.lw.domain.Employee;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import java.util.ArrayList;

/**
 * Created by LW on 2018/6/28.
 */
public class EmplyeeCrudRepositoryTest {


    /**
     * 应用程序上下文
     */
    private ApplicationContext context = null;
    private EmplyeeCrudRepository emplyeeCrudRepository = null;

    /**
     * 通过Junit 中的 @Before 注解 在setup方法中 初始化 ApplicationContext
     */
    @Before
    public void setup() {
        context = new ClassPathXmlApplicationContext("beans-new.xml");
        emplyeeCrudRepository = context.getBean(EmplyeeCrudRepository.class);
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
    public void testSave() {
        ArrayList<Employee> employees = new ArrayList<>();

        Employee employee = null;
        for (int i = 0; i < 100; i++) {
            employee = new Employee();
            employee.setName("employee" + (i + 1));
            employee.setAge(100 - i);
            employees.add(employee);
        }
        emplyeeCrudRepository.save(employees);
    }
}