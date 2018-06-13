package com.lw.controller;

// Twitter 分布式 id生成器   保证唯一

import com.lw.pojo.JSONResult;
import com.lw.pojo.SysUser;
import com.lw.service.UserService;
import org.n3r.idworker.Sid;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Date;
import java.util.List;

/**
 * Created by LW on 2018/6/6.
 */
@RestController
@RequestMapping("mybatis")
public class MyBatisCRUDController {

    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    private UserService userService;

    private Sid sid;

    @RequestMapping("/saveUser")
    public JSONResult saveUser() throws Exception {

        String userId = sid.nextShort();

        SysUser user = new SysUser();
        user.setId(userId);
        user.setUsername("lee" + new Date());
        user.setNickname("lee" + new Date());
        user.setPassword("abc123");
        user.setIsDelete(0);
        user.setRegistTime(new Date());

        userService.saveUser(user);

        return JSONResult.success("save successfully");
    }

    @RequestMapping("/updateUser")
    public JSONResult updateUser(SysUser user) {

        user.setId("180607AZ4F1XM140");
        user.setUsername("lee" + new Date());
        user.setNickname("dahei");
        user.setPassword("dahuang");
        user.setIsDelete(0);
        user.setRegistTime(new Date());

        userService.updateUser(user);

        return JSONResult.success("update successfully");
    }

    @RequestMapping("/findOne")
    public JSONResult findOne() {
        SysUser user = userService.queryUserById("180607AZ4F1XM140");

        return JSONResult.success(user);
    }

    @RequestMapping("/findAll")
    public JSONResult findAll(SysUser user, Integer page, Integer pageSize) {
        if (page == null) {
            page = 1;
        }
        if (pageSize == null) {
            pageSize = 3;
        }
        List<SysUser> sysUsers = userService.queryUserList(user, page, pageSize);
        return JSONResult.success(sysUsers);
    }

    @RequestMapping("/queryUserByIdCustom")
    public JSONResult queryUserByIdCustom(String userId) {

        return JSONResult.success(userService.queryUserByIdCustom(userId));
    }

    @RequestMapping("/testTransactional")
    @Transactional(propagation = Propagation.REQUIRED)
    public JSONResult testTransactional() throws Exception {

        String userId = sid.nextShort();

        SysUser user = new SysUser();
        user.setId(userId);
        user.setUsername("testTransactional" + new Date());
        user.setNickname("testTransactional" + new Date());
        user.setPassword("abc123");
        user.setIsDelete(0);
        user.setRegistTime(new Date());

        userService.saveUser(user);

        int a = 1 / 0;

        user.setNickname("nxy");
        userService.updateUser(user);

        return JSONResult.success(user);
    }
}
