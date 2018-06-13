package com.lw.service.impl;

import com.github.pagehelper.PageHelper;
import com.lw.mapper.SysUserMapper;
import com.lw.mapper.SysUserMapperCustom;
import com.lw.pojo.SysUser;
import com.lw.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import tk.mybatis.mapper.entity.Example;

import java.util.List;

/**
 * Created by LW on 2018/6/6.
 */
@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private SysUserMapper userMapper;

    @Autowired
    private SysUserMapperCustom sysUserMapperCustom;

    @Override
    @Transactional(propagation = Propagation.REQUIRED)
    public void saveUser(SysUser user) throws Exception {
        int result = userMapper.insert(user);
        System.out.println("saveUser result: " + result);
    }

    @Override
    @Transactional(propagation = Propagation.REQUIRED)
    public void updateUser(SysUser user) {
        int result = userMapper.updateByPrimaryKey(user);
        System.out.println("updateUser result: " + result);
    }

    @Override
    @Transactional(propagation = Propagation.REQUIRED)
    public void deleteUser(String userId) {
        userMapper.deleteByPrimaryKey(userId);
    }

    @Override
    @Transactional(propagation = Propagation.SUPPORTS)
    public SysUser queryUserById(String userId) {
        return userMapper.selectByPrimaryKey(userId);
    }

    @Override
    @Transactional(propagation = Propagation.SUPPORTS)
    public List<SysUser> queryUserList(SysUser user, Integer page, Integer pageSize) {

        PageHelper.startPage(page, pageSize);

        Example example = new Example(SysUser.class);
        Example.Criteria criteria = example.createCriteria();

        if (!StringUtils.isEmpty(user.getNickname())) {
            criteria.andLike("nickname", "%" + user.getNickname() + "%");
        }
        example.orderBy("registTime").desc();

        List<SysUser> sysUsers = userMapper.selectByExample(example);
        return sysUsers;
    }

    @Override
    @Transactional(propagation = Propagation.SUPPORTS)
    public SysUser queryUserByIdCustom(String userId) {

        List<SysUser> userList = sysUserMapperCustom.queryUserByIdCustom(userId);

        if (userList != null && !userList.isEmpty()) {
            return userList.get(0);
        }
        return null;
    }
}
