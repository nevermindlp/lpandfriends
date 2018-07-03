package com.lw.pojo;

import com.lw.custom.SimpleCustomAnnotation;

/**
 * Created by LW on 2018/7/3.
 */

@SimpleCustomAnnotation(stringValue = "WildDog", intValue = 3)
public class WildDog extends Dog {

    @Override
    public void eat() {
        super.eat();
    }

    @Override
    @SuppressWarnings("deprecation")
    public void fly() {
        super.fly();
    }

    @Override
    public void sleep() {
        super.sleep();
    }
}
