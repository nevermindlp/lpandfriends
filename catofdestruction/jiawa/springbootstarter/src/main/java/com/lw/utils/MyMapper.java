package com.lw.utils;

import tk.mybatis.mapper.common.Mapper;
import tk.mybatis.mapper.common.MySqlMapper;

/**
 * Created by LW on 2018/6/5.
 */
public interface MyMapper<T> extends Mapper<T>, MySqlMapper<T> {
    // 特别注意：该接口不能被扫描，否则会出错
}
