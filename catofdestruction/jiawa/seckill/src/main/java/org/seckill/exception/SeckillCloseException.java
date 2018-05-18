package org.seckill.exception;

/**
 * 秒杀关闭异常（时间到、库存为0等等，不应该再执行秒杀）
 * Created by LW on 2018/5/17.
 */
public class SeckillCloseException extends SeckillException {

    public SeckillCloseException(String message) {
        super(message);
    }

    public SeckillCloseException(String message, Throwable cause) {
        super(message, cause);
    }
}
