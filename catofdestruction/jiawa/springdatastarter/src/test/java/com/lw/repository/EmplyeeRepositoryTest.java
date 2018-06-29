package com.lw.repository;

import com.lw.domain.Employee;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by LW on 2018/6/28.
 */
public class EmplyeeRepositoryTest {

    /**
     * 应用程序上下文
     */
    private ApplicationContext context = null;
    private EmplyeeRepository emplyeeRepository = null;

    /**
     * 通过Junit 中的 @Before 注解 在setup方法中 初始化 ApplicationContext
     */
    @Before
    public void setup() {
        context = new ClassPathXmlApplicationContext("beans-new.xml");
        emplyeeRepository = context.getBean(EmplyeeRepository.class);
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
    public void findByName() throws Exception {
        // org.springframework.data.jpa.repository.support.SimpleJpaRepository@4c03a37
        System.out.println(emplyeeRepository);

        Employee employee = emplyeeRepository.findByName("zhangsan");
        System.out.println(employee);
    }

    @Test
    public void findByNameStartingWithAndAgeLessThan() throws Exception {
        List<Employee> employees =
                emplyeeRepository.findByNameStartingWithAndAgeLessThan("test", 22);
        employees.forEach(employee -> {
            System.out.println(employee);
        });
    }

    @Test
    public void findByNameEndingWithAndAgeGreaterThan() throws Exception {
        List<Employee> employees =
                emplyeeRepository.findByNameEndingWithAndAgeGreaterThan("6", 20);
        employees.forEach(System.out::println);
    }

    @Test
    public void findByNameInOrAgeLessThan() throws Exception {
        ArrayList<String> names = new ArrayList<>();
        names.add("test1");
        names.add("wangwu");

        List<Employee> employees =
                emplyeeRepository.findByNameInOrAgeLessThan(names, 22);
        employees.forEach(System.out::println);
    }

    @Test
    public void getByMaxId() throws Exception {
        Employee employee = emplyeeRepository.getByMaxId();
        System.out.println(employee);
    }

    @Test
    public void queryWithParams1() throws Exception {
        List<Employee> employees =
                emplyeeRepository.queryWithParams1("wangwu", 24);
        employees.forEach(System.out::println);
    }

    @Test
    public void queryWithParams2() throws Exception {
        List<Employee> employees =
                emplyeeRepository.queryWithParams2("wangwu", 24);
        employees.forEach(System.out::println);
    }

    @Test
    public void queryNameLike1() throws Exception {
        List<Employee> employees =
                emplyeeRepository.queryNameLike1("Jack");
        employees.forEach(System.out::println);
    }

    @Test
    public void queryNameLike2() throws Exception {
        List<Employee> employees =
                emplyeeRepository.queryNameLike2("Tom");
        employees.forEach(System.out::println);
    }

    @Test
    public void queryCount() throws Exception {
        long count = emplyeeRepository.queryCount();
        System.out.println("count:" + count);
    }

    @Test
    public void updateAgeById() throws Exception {
        emplyeeRepository.updateAgeById(2, 30);
    }

    @Test
    public void updateNameById() throws Exception {
        emplyeeRepository.updateNameById(3, "laowang");
    }

    @Test
    public void removeById() throws Exception {
        emplyeeRepository.removeById(7);
    }
}