package com.lw.dao;

import com.lw.domain.Student;
import org.springframework.jdbc.core.JdbcTemplate;

import java.util.ArrayList;
import java.util.List;

/**
 * StudentDAO 访问接口 实现类：通过Spring jdbc的操作方式
 *
 * Created by LW on 2018/6/26.
 */
public class StudentDaoSpringJdbcImpl implements StudentDao {

    /**
     * 通过set方法注入
     */
    private JdbcTemplate jdbcTemplate;

    public List<Student> queryAll() {

        final List<Student> students = new ArrayList<Student>();

        String sql = "select id, name, age from student";
//        jdbcTemplate.query(sql, new RowCallbackHandler() {
//            public void processRow(ResultSet rs) throws SQLException {
//                Student student = null;
//                while (rs.next()) {
//                    int id = rs.getInt("id");
//                    String name = rs.getString("name");
//                    int age = rs.getInt("age");
//
//                    student = new Student(id, name, age);
//                    students.add(student);
//                }
//            }
//        });

        jdbcTemplate.query(sql, rs -> {

            Student student = null;
            while (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("name");
                int age = rs.getInt("age");

                student = new Student(id, name, age);
                students.add(student);
            }
        });
        return students;
    }

    public void save(Student student) {
        String sql = "insert into student(name, age) values(?,?)";
        jdbcTemplate.update(sql, student.getName(), student.getAge());
    }

    public JdbcTemplate getJdbcTemplate() {
        return jdbcTemplate;
    }

    public void setJdbcTemplate(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }
}
