package com.lw.custom;

import java.lang.annotation.*;

/**
 * Created by LW on 2018/7/3.
 */

@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface Table {
    String value();
}
