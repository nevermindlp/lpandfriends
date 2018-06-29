package com.lw.dao;

import com.lw.domain.Student;

import java.util.List;

/**
 * StudentDAO 访问接口
 *
 * Created by LW on 2018/6/26.
 */
public interface StudentDao {
    /**
     * 查询所有学生
     * @return 所有学生
     */
    public List<Student> queryAll();

    /**
     * 添加一个学生
     * @param student 待添加的学生
     */
    public void save(Student student);
}
