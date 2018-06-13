package com.lw.service;

import com.lw.pojo.SysUser;

import java.util.List;

/**
 * Created by LW on 2018/6/6.
 */
public interface UserService {
    public void saveUser(SysUser user) throws Exception;
    public void updateUser(SysUser user);
    public void deleteUser(String userId);
    public SysUser queryUserById(String userId);
    public List<SysUser> queryUserList(SysUser user, Integer page, Integer pageSize);
    public SysUser queryUserByIdCustom(String userId);
}
