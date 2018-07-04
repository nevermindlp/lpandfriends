package com.lw.domain;

import org.hibernate.annotations.GenericGenerator;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

/**
 * Created by LW on 2018/7/4.
 */
@Entity
public class IDCard {
    private String cardID;
    private String name;

    public IDCard() {
    }

    public IDCard(String cardID, String name) {
        this.cardID = cardID;
        this.name = name;
    }

    @GeneratedValue(generator = "cardID")
    @GenericGenerator(name = "cardID", strategy = "assigned")
    @Id
    @Column(length = 18, nullable = false)
    public String getCardID() {
        return cardID;
    }

    public void setCardID(String cardID) {
        this.cardID = cardID;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
