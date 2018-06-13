package com.lw.mapper;

import com.lw.pojo.SysUser;

import java.util.List;

public interface SysUserMapperCustom {

    List<SysUser> queryUserByIdCustom(String id);
}