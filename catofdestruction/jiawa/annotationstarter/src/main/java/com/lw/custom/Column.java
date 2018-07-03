package com.lw.custom;

import java.lang.annotation.*;

/**
 * Created by LW on 2018/7/3.
 */

@Target(ElementType.FIELD)
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface Column {
    String name();
    boolean nullable() default true;
}
