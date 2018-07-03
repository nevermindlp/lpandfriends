package com.lw.util;

import com.lw.custom.Column;
import com.lw.custom.Table;

import java.lang.annotation.Annotation;
import java.lang.annotation.ElementType;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

/**
 * Created by LW on 2018/7/3.
 */
public class AnnotationUtil {

    public static void showAllRuntimeAnnotation(Class aClass, ElementType elementType) {

        if (elementType == ElementType.TYPE) {
            Annotation[] annotations = aClass.getAnnotations();
            for (Annotation annotation : annotations) {
                System.out.println(aClass.getSimpleName() + " has TYPE ANNOTATION: " + annotation.toString());
            }
        } else if (elementType == ElementType.FIELD) {
            Field[] declaredFields = aClass.getDeclaredFields();
            for (Field field : declaredFields) {
                Annotation[] annotations = field.getAnnotations();
                for (Annotation annotation : annotations) {
                    System.out.println(aClass.getSimpleName() + " has FIELD ANNOTATION: " + annotation.toString());
                }
            }
        } else if (elementType == ElementType.METHOD) {
            Method[] methods = aClass.getMethods();
            for (Method method : methods) {
                Annotation[] declaredAnnotations = method.getDeclaredAnnotations();
                for (Annotation declaredAnnotation : declaredAnnotations) {
                    System.out.println(aClass.getSimpleName() + " has METHOD ANNOTATION: " + declaredAnnotation.toString());
                }
            }
        }
    }

    public static void showAllRuntimeAnnotation(Class aClass) {

        Annotation[] annotations = aClass.getAnnotations();
        for (Annotation annotation : annotations) {
            System.out.println(aClass.getSimpleName() + " has TYPE ANNOTATION: " + annotation.toString());
        }

        Field[] declaredFields = aClass.getDeclaredFields();
        for (Field field : declaredFields) {
            Annotation[] fieldAnnotations = field.getAnnotations();
            for (Annotation annotation : fieldAnnotations) {
                System.out.println(aClass.getSimpleName() + " has FIELD ANNOTATION: " + annotation.toString());
            }
        }

        Method[] methods = aClass.getMethods();
        for (Method method : methods) {
            Annotation[] declaredAnnotations = method.getDeclaredAnnotations();
            for (Annotation declaredAnnotation : declaredAnnotations) {
                System.out.println(aClass.getSimpleName() + " has METHOD ANNOTATION: " + declaredAnnotation.toString());
            }
        }
    }

    public static String querySql(Object object) {
        StringBuilder sql = new StringBuilder();
        Class<?> aClass = object.getClass();
        if (aClass.isAnnotationPresent(Table.class)) {
            String tableName = aClass.getAnnotation(Table.class).value();
            sql.append("select * from ").append(tableName).append(" where 1=1");
        } else {
            return null;
        }

        Field[] declaredFields = aClass.getDeclaredFields();
        for (Field field : declaredFields) {
            if (field.isAnnotationPresent(Column.class)) {

                String columnName = field.getAnnotation(Column.class).name();
                Object columnValue = getColumnValue(object, columnName);
                if (columnValue == null) {
                    continue;
                }

                sql.append(" and ").append(columnName).append("=");
                if (columnName instanceof String) {
                    sql.append("'").append(columnValue).append("'");
                }
                else {
                    sql.append(columnValue);
                }
            }
        }

        return sql.toString();
    }

    private static Object getColumnValue(Object object, String field) {

        String getMethodStr = "get" + field.substring(0, 1).toUpperCase() + field.substring(1);
        Object value = null;
        try {
            Method getMethod = object.getClass().getMethod(getMethodStr);
            value = getMethod.invoke(object);
        } catch (NoSuchMethodException e) {
            e.printStackTrace();
        } catch (InvocationTargetException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        }

        return value;
    }
}
