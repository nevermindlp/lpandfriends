package com.lw.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.lw.pojo.JSONResult;
import com.lw.pojo.SysUser;
import com.lw.pojo.User;
import com.lw.utils.RedisOperator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;
import java.util.*;

/**
 * Created by LW on 2018/6/8.
 */
@RestController
@RequestMapping("redis")
public class RedisTestController {

    @Autowired
    private StringRedisTemplate redisTemplate;

    @Autowired
    private RedisOperator redis;

    @RequestMapping("/testStringRedisTemplate")
    public JSONResult testStringRedisTemplate() throws JsonProcessingException {

        String key = "dahuangRedis:hello";
        redisTemplate.opsForValue().set(key, "Hello StringRedisTemplate");
        System.out.println(redisTemplate.opsForValue().get(key));

        SysUser user = new SysUser();
        user.setId("10JQKA");
        user.setUsername("10JQKA" + new Date());
        user.setNickname("10JQKA" + new Date());
        user.setPassword("10JQKA");
        user.setIsDelete(0);
        user.setRegistTime(new Date());

        String key1 = "json:userRedis";

        // 使用ObjectMapper 将java对象 转换成字符串 存储进redis
        // 也可以使用 protostuff 替换 ObjectMapper
        ObjectMapper objectMapper = new ObjectMapper();
        String jsonString = objectMapper.writeValueAsString(user);
        redisTemplate.opsForValue().set(key1, jsonString);

        // 从redis中获取对象jsonString 并使用ObjectMapper 转化为java对象
        String cacheString = redisTemplate.opsForValue().get(key1);
        System.out.println("cacheString = " + cacheString);
        SysUser cacheUser = null;
        try {
            cacheUser = objectMapper.readValue(jsonString, SysUser.class);
        } catch (IOException e) {
            e.printStackTrace();
        }
        System.out.println("cacheUser = " + cacheUser);

        return JSONResult.success(cacheUser);
    }

    @RequestMapping("/testRedisOperator")
    public JSONResult testRedisOperator() {

        String key = "dahuangRedis:12345";
        redis.setObj(key, "123456", 60 * 60);

        String cacheResult = (String) redis.getObj(key, String.class);
        System.out.println(cacheResult);


        // Cache List
        User user = new User();
        user.setAge(18);
        user.setName("xiao huang");
        user.setPassword("123456");
        user.setBirthday(new Date());

        User u1 = new User();
        u1.setAge(19);
        u1.setName("da huang");
        u1.setPassword("123456");
        u1.setBirthday(new Date());

        User u2 = new User();
        u2.setAge(17);
        u2.setName("xiao hei");
        u2.setPassword("123456");
        u2.setBirthday(new Date());

        List<User> userList = new ArrayList<>();
        userList.add(user);
        userList.add(u1);
        userList.add(u2);

        Map<String, Object> map = new HashMap<>();
        map.put("key1", "butioy");
        map.put("key2", "protostuff");
        map.put("key3", "serialize");


        String key1 = "json:info:userlist";

        redis.setObj(key1, userList, 60 * 60);

        Object cacheUserListResult = redis.getObj(key1, List.class);
        System.out.println(cacheUserListResult);

        return JSONResult.success(cacheUserListResult);
    }
}
