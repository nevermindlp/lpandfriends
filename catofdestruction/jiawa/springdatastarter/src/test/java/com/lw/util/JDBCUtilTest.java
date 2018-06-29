package com.lw.util;

import org.junit.Assert;
import org.junit.Test;

import java.sql.Connection;

/**
 * Created by LW on 2018/6/26.
 */
public class JDBCUtilTest {
    @Test
    public void getConnection() throws Exception {
        Connection connection = JDBCUtil.getConnection();
        Assert.assertNotNull(connection);
    }
}