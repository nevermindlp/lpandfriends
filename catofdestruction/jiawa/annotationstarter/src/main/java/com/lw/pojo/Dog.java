package com.lw.pojo;


import com.lw.custom.Column;
import com.lw.custom.SimpleCustomAnnotation;
import com.lw.custom.Table;
import lombok.Data;

/**
 * Created by LW on 2018/7/3.
 */

@Data
@SimpleCustomAnnotation(stringValue = "Dog")
@Table("Dog")
public class Dog implements Animal {

    @SimpleCustomAnnotation(stringValue = "name")
    @Column(name = "name")
    private String name;
    @Column(name = "age")
    private int age;
    private Integer weight;

    public void eat() {
        System.out.println("eat");
    }

    @Deprecated
    public void fly() {
        System.out.println(this.getClass().getSimpleName() + " can not fly");
    }

    @SimpleCustomAnnotation(stringValue = "sleep")
    public void sleep() {
        System.out.println("sleep");
    }
}
