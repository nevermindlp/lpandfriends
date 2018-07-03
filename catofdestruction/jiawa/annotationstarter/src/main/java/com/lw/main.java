package com.lw;

import com.lw.entity.Camera;
import com.lw.entity.YellowDog;
import com.lw.pojo.Animal;
import com.lw.pojo.Dog;
import com.lw.pojo.WildDog;
import com.lw.util.AnnotationUtil;

import java.lang.reflect.Method;

/**
 * Created by LW on 2018/7/3.
 */
public class main {

    public static void main(String[] args) throws Exception {
        Dog dog = new Dog();
        dog.fly();

        WildDog wildDog = new WildDog();
        wildDog.fly();

        System.out.println("\n========================= AnnotationUtil 打印注解信息 start ===========================\n");
        AnnotationUtil.showAllRuntimeAnnotation(Animal.class);
        AnnotationUtil.showAllRuntimeAnnotation(Dog.class);
        AnnotationUtil.showAllRuntimeAnnotation(WildDog.class);
        System.out.println("\n========================= AnnotationUtil 打印注解信息 end   ===========================\n");

        System.out.println("\n========================= @Data注解自动为Dog和其子类添加了get set 方法 ===========================\n");
        Method[] methods = WildDog.class.getMethods();
        for (Method method : methods) {
            String methodName = method.getName();
            if (methodName.contains("set") || methodName.contains("get")) {
                System.out.println(methodName);
            }
        }

        System.out.println("\n========================= 自定义注解测试 ===========================\n");
        YellowDog yellowDog = new YellowDog();
        yellowDog.setName("Da Huang");
        yellowDog.setAge(9);
        yellowDog.setWeight(3);

        yellowDog.setColor("Yellow");
        yellowDog.setOwner("Niu Xinyuan");

        String querySql = AnnotationUtil.querySql(yellowDog);
        System.out.println(querySql);

        Camera camera = new Camera();
        camera.setId(1);
        camera.setName("TK");
        camera.setLocation("后厂村");

        String querySql1 = AnnotationUtil.querySql(camera);
        System.out.println(querySql1);
    }
}
