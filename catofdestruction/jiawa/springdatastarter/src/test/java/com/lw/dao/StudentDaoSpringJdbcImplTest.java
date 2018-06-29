package com.lw.dao;

import com.lw.domain.Student;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import java.util.List;

/**
 * Created by LW on 2018/6/26.
 */
public class StudentDaoSpringJdbcImplTest {

    /**
     * 应用程序上下文
     */
    private ApplicationContext context = null;
    private StudentDao studentDao = null;

    /**
     * 通过Junit 中的 @Before 注解 在setup方法中 初始化 ApplicationContext
     */
    @Before
    public void setup() {
        context = new ClassPathXmlApplicationContext("beans.xml");
        studentDao = (StudentDao) context.getBean("studentDao");
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
    public void queryAll() throws Exception {
        List<Student> students = studentDao.queryAll();
        for (Student student :
                students) {
            System.out.println("student ==> " + student);
        }
    }

    @Test
    public void save() throws Exception {
        Student student = new Student("Tom", 31);
        studentDao.save(student);
    }
}