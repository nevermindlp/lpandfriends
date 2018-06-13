package com.lw.controller;

import com.lw.pojo.JSONResult;
import com.lw.pojo.Resource;
import com.lw.pojo.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Date;

/**
 * Created by LW on 2018/6/1.
 */
@RestController
@RequestMapping("/starter")
public class UserController {

    @Autowired
    private Resource resource;

    @RequestMapping("/getUser")
    public JSONResult getUser() {
        User user = new User();
        user.setName("dahuang");
        user.setAge(18);
        user.setBirthday(new Date());
        user.setPassword("xiaohuang");
        user.setDesc("dog");
        return JSONResult.success(user);
    }

    @RequestMapping("/getResource")
    public JSONResult getResourceByConfiguration() {
        Resource res = new Resource();
        res.setName(resource.getName());
        res.setWebsite(resource.getWebsite());
        res.setLanguage(resource.getLanguage());
        return JSONResult.success(res);
    }
}
