package com.lw.domain;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Set;

/**
 * 雇员 先开发实体类 => 自动生成数据表
 *
 * Created by LW on 2018/6/27.
 */

@Entity
@Table(name = "test_lw_multi_keys8", schema = "spring_data")
//@IdClass(EmployeeMultiKeysClass.class)
public class Employee implements Serializable {
    private Integer id;
    private String name;
    private Integer age;

    // Embeddable
    private Address address;
    // Transient
    private double salary;

    // one to one
    private IdCard idCard;

    // many to one
    private Leader leader;

    // many to many
    private Set<Role> roles;

    public Employee() {
    }

//    @GeneratedValue(generator = "multiID")
//    @GenericGenerator(name = "multiID", strategy = "assigned")
    @GeneratedValue
    @Id
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

//    @Id
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

    @OneToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "cid", unique = true)
    public IdCard getIdCard() {
        return idCard;
    }

    public void setIdCard(IdCard idCard) {
        this.idCard = idCard;
    }

    @ManyToOne(cascade = CascadeType.ALL, fetch = FetchType.EAGER)
    @JoinColumn(name = "lid", referencedColumnName = "leaderId")
    public Leader getLeader() {
        return leader;
    }

    public void setLeader(Leader leader) {
        this.leader = leader;
    }

    @ManyToMany(cascade = CascadeType.ALL)
    @JoinTable(name = "employee_role",
            joinColumns = {@JoinColumn(name = "eid")},
            inverseJoinColumns = {@JoinColumn(name = "rid")})
    public Set<Role> getRoles() {
        return roles;
    }

    public void setRoles(Set<Role> roles) {
        this.roles = roles;
    }

    @Override
    public String toString() {
        return "Employee{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", age=" + age +
                ", address=" + address +
                ", salary=" + salary +
                ", idCard=" + idCard +
                ", leader=" + leader +
//                ", roles=" + roles +
                '}';
    }
}
