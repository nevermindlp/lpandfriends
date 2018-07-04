package com.lw.domain;

import javax.persistence.Embeddable;

/**
 * Created by LW on 2018/7/4.
 */
@Embeddable
public class Address {
    private String postCode;
    private String address;
    private String phone;

    public String getPostCode() {
        return postCode;
    }

    public void setPostCode(String postCode) {
        this.postCode = postCode;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }
}
