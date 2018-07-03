package com.lw.custom;

import java.lang.annotation.*;

/**
 * Created by LW on 2018/7/3.
 */
@Target({ElementType.TYPE, ElementType.FIELD, ElementType.METHOD})
@Retention(RetentionPolicy.RUNTIME)
@Inherited
@Documented
public @interface SimpleCustomAnnotation {
    String stringValue() default "";
    int intValue() default 0;
}
