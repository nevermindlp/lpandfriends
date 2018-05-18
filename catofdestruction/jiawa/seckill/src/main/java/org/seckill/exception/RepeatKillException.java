package org.seckill.exception;

/**
 * 重复秒杀异常（运行期异常，不需要手动try catch）
 * spring声明式事务只接收运行期异常 回滚策略，非运行期不会回滚
 * Created by LW on 2018/5/17.
 */
public class RepeatKillException extends SeckillException {

    public RepeatKillException(String message) {
        super(message);
    }

    public RepeatKillException(String message, Throwable cause) {
        super(message, cause);
    }
}
