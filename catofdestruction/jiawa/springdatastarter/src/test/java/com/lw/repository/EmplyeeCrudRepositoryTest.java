package com.lw.repository;

import com.lw.domain.*;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Set;

/**
 * Created by LW on 2018/6/28.
 */
public class EmplyeeCrudRepositoryTest {


    /**
     * 应用程序上下文
     */
    private ApplicationContext context = null;
    private EmplyeeCrudRepository emplyeeCrudRepository = null;
    private TaskRepository taskRepository = null;

    /**
     * 通过Junit 中的 @Before 注解 在setup方法中 初始化 ApplicationContext
     */
    @Before
    public void setup() {
        context = new ClassPathXmlApplicationContext("beans-new.xml");
        emplyeeCrudRepository = context.getBean(EmplyeeCrudRepository.class);

        taskRepository = context.getBean(TaskRepository.class);
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

        Role role1 = new Role("admin");
        Role role2 = new Role("super");
        Role role3 = new Role("normal");
        Role role4 = new Role("low");
        Set<Role> rolesA = new HashSet<>();
        rolesA.add(role1);
        rolesA.add(role2);
        rolesA.add(role3);
        rolesA.add(role4);

        Set<Role> rolesB = new HashSet<>();
        rolesB.add(role3);


        ArrayList<Employee> employees = new ArrayList<>();

        Leader leader = new Leader("leader nxy1");

        Address address = null;
        IdCard idCard = null;

        Set<Task> tasks = new HashSet<>();
        tasks.add(new Task("task1"));
        tasks.add(new Task("task2"));
        tasks.add(new Task("task3"));
        taskRepository.save(tasks);


        leader.setTasks(tasks);

        Employee employee = null;

        for (int i = 0; i < 100; i++) {
            String name = "employee" + (i + 1);

            address = new Address("100091", "addr" + (i+1), "13810099999");

            idCard = new IdCard("110105198804015" + (100 + (i+1)), "card" + (i+1));

            employee = new Employee();
//            employee.setId(i*2);
            employee.setName(name);
            employee.setAge(100 - i);

            // Embeddable
            employee.setAddress(address);
            // one to one
            employee.setIdCard(idCard);
            // many to one
            employee.setLeader(leader);
            // many to many
            employee.setRoles(i % 2 == 0 ? rolesA : rolesB);

            employees.add(employee);
        }

        emplyeeCrudRepository.save(employees);
    }
}