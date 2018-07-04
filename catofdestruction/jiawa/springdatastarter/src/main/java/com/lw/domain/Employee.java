package com.lw.domain;

import org.hibernate.annotations.GenericGenerator;

import javax.persistence.*;
import java.io.Serializable;

/**
 * 雇员 先开发实体类 => 自动生成数据表
 *
 * Created by LW on 2018/6/27.
 */

@Entity
@Table(name = "test_lw_multiKeys6", schema = "spring_data")
@IdClass(EmployeeMultiKeysClass.class)
public class Employee implements Serializable {
    private Integer id;
    private String name;
    private Integer age;
    private Address address;
    private double salary;

    public Employee() {
    }

    @GeneratedValue(generator = "multiID")
    @GenericGenerator(name = "multiID", strategy = "assigned")
    @Id
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    @Id
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

    public Address getAddress() {
        return address;
    }

    public void setAddress(Address address) {
        this.address = address;
    }

    @Transient
    public double getSalary() {
        return salary;
    }

    public void setSalary(double salary) {
        this.salary = salary;
    }

    @Override
    public String toString() {
        return "Employee{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", age=" + age +
                ", address=" + address +
                ", salary=" + salary +
                '}';
    }
}
