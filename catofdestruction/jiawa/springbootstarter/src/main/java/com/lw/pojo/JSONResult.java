package com.lw.pojo;

import com.fasterxml.jackson.databind.ObjectMapper;

/**
 * Created by LW on 2018/6/1.
 */
public class JSONResult {
    private static final ObjectMapper MAPPER = new ObjectMapper();

    private Integer status;
    private String msg;
    private Object data;

    public JSONResult(Integer status, String msg, Object data) {
        this.status = status;
        this.msg = msg;
        this.data = data;
    }

    public static JSONResult success(Object data) {
        return new JSONResult(200, "success", data);
    }

    public static JSONResult errorMsg(String msg) {
        return new JSONResult(500, msg, null);
    }

    public static JSONResult errorMap(Object data, String msg) {
        return new JSONResult(501, msg, data);
    }

    public static JSONResult errorTokenMsg(String msg) {
        return new JSONResult(502, msg, null);
    }

    public static JSONResult errorException(String msg) {
        return new JSONResult(555, msg, null);
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public Object getData() {
        return data;
    }

    public void setData(Object data) {
        this.data = data;
    }
}
