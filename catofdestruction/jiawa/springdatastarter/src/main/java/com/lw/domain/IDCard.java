package com.lw.domain;

import org.hibernate.annotations.GenericGenerator;

import javax.persistence.*;
import java.io.Serializable;

/**
 * Created by LW on 2018/7/5.
 */

@Entity
@Table(name = "test_lw_idcard")
public class IdCard implements Serializable {

    private String cardID;
    private String cardInfo;
    private Employee employee;

    public IdCard() {
    }

    public IdCard(String cardID, String cardInfo) {
        this.cardID = cardID;
        this.cardInfo = cardInfo;
    }

    @Id
//    @GeneratedValue(generator = "cccid") // detached entity passed to persist
    @GenericGenerator(name = "cardIDGO", strategy = "assigned")
    @Column(length = 18)
    public String getCardID() {
        return cardID;
    }

    public void setCardID(String cardID) {
        this.cardID = cardID;
    }

    public String getCardInfo() {
        return cardInfo;
    }

    public void setCardInfo(String cardInfo) {
        this.cardInfo = cardInfo;
    }

    @OneToOne(mappedBy = "idCard")
    public Employee getEmployee() {
        return employee;
    }

    public void setEmployee(Employee employee) {
        this.employee = employee;
    }

    @Override
    public String toString() {
        return "IdCard{" +
                "cardID='" + cardID + '\'' +
                ", cardInfo='" + cardInfo + '\'' +
//                ", employee=" + employee + // FIXME: 2018/7/10 互相引用如果重写toString 属性 会有问题  java.lang.StackOverflowError
                '}';
    }
}
