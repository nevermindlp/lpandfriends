package com.lw.domain;

import java.io.Serializable;

/**
 * Created by LW on 2018/7/4.
 */

// TODO: https://blog.csdn.net/qq_35056292/article/details/77892012
// TODO: 使用联合主键时 不能使用 @GeneratedValue 否则会报错
public class EmployeeMultiKeysClass implements Serializable {
    private Integer id;
    private String name;

    public EmployeeMultiKeysClass() {
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        EmployeeMultiKeysClass that = (EmployeeMultiKeysClass) o;

        if (id != null ? !id.equals(that.id) : that.id != null) return false;
        return name != null ? name.equals(that.name) : that.name == null;

    }

    @Override
    public int hashCode() {
        int result = id != null ? id.hashCode() : 0;
        result = 31 * result + (name != null ? name.hashCode() : 0);
        return result;
    }
}
