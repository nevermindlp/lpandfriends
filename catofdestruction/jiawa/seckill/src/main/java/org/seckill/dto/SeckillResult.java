package org.seckill.dto;

/**
 * DTO的主要职责是web层到service层的数据传递
 * 泛型的原因：需要一个VO来封装数据（json）结果，所有的ajax请求返回类型都为 SeckillResult<T>
 * Created by LW on 2018/5/21.
 */
public class SeckillResult<T> {
    private boolean success;
    private T data;
    private String error;

    public SeckillResult(boolean success, T data) {
        this.success = success;
        this.data = data;
    }

    public SeckillResult(boolean success, String error) {
        this.success = success;
        this.error = error;
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public T getData() {
        return data;
    }

    public void setData(T data) {
        this.data = data;
    }

    public String getError() {
        return error;
    }

    public void setError(String error) {
        this.error = error;
    }
}