package com.lw.domain;

import javax.persistence.*;

/**
 * 雇员 先开发实体类 => 自动生成数据表
 *
 * Created by LW on 2018/6/27.
 */

@Entity
@Table(name = "test_employee_lw")
public class Employee {
    private Integer id;
    private String name;
    private Integer age;

    @GeneratedValue
    @Id
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    @Column(length = 20, nullable = false)
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Column(nullable = false)
    public Integer getAge() {
        return age;
    }

    public void setAge(Integer age) {
        this.age = age;
    }

    @Override
    public String toString() {
        return "Employee{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", age=" + age +
                '}';
    }
}
