package org.seckill.exception;

/**
 * 所有秒杀相关业务异常
 * Created by LW on 2018/5/17.
 */
public class SeckillException extends RuntimeException {

    public SeckillException(String message) {
        super(message);
    }

    public SeckillException(String message, Throwable cause) {
        super(message, cause);
    }
}
