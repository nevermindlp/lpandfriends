package com.lw.dao;

import com.lw.domain.Student;
import org.junit.Test;

import java.util.List;

/**
 * Created by LW on 2018/6/26.
 */
public class StudentDaoImplTest {

    @Test
    public void queryAll() throws Exception {
        StudentDao studentDao = new StudentDaoImpl();
        List<Student> students = studentDao.queryAll();
        for (Student student :
                students) {
            System.out.println("student ==> " + student);
        }
    }

    @Test
    public void save() throws Exception {
        StudentDao studentDao = new StudentDaoImpl();
        Student student = new Student("Jack", 30);
        studentDao.save(student);
    }
}