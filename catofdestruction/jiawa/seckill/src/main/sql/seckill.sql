-- 秒杀执行存储过程

-- mysql console结尾的 ; 转换为 $$
DELIMITER $$
-- 定义储存过程
-- 参数：in 表示输入参数  out 表示输出参数
-- row_count() 内置函数： 返回上一条 修改类型 sql（即delete insert update）的影响行数
-- row_count() 0:未修改数据 >0:表示修改的行数数目 <0: sql错误/未执行修改sql

/*
SUCCESS(1, "秒杀成功"),
END(0, "秒杀结束"),
REPEAT_KILL(-1, "重复秒杀"),
INNER_ERROR(-2, "系统异常"),
DATA_REWRITE(-3, "数据篡改"),
UNREGISTERED(-4, "未注册");
*/
CREATE PROCEDURE seckill.execute_seckill

  (IN v_seckill_id BIGINT, IN v_phone BIGINT,
    IN v_kill_time TIMESTAMP, OUT r_result INT)
  BEGIN
    DECLARE insert_count INT DEFAULT 0;
    DECLARE update_count INT DEFAULT 0;

    START TRANSACTION;
    INSERT IGNORE INTO success_killed
      (seckill_id, user_phone, create_time, state)
      VALUES (v_seckill_id, v_phone, v_kill_time, 0);
    SELECT row_count() INTO insert_count;

    IF (insert_count = 0) THEN
      ROLLBACK;
      SET r_result = -1;
    ELSEIF (insert_count < 0) THEN
      ROLLBACK;
      SET r_result = -2;
    ELSE
      UPDATE seckill
        SET number = number - 1
      WHERE seckill_id = v_seckill_id
      AND end_time > v_kill_time
      AND start_time < v_kill_time
      AND number > 0;

      SELECT row_count() INTO update_count;
      IF (update_count = 0) THEN
        ROLLBACK;
        SET r_result = 0;
      ELSEIF (update_count < 0) THEN
        ROLLBACK;
        SET r_result = -2;
      ELSE
        COMMIT;
        SET r_result = 1;
      END IF;

    END IF;

  END;
$$
-- 储存过程定义结束


-- 调用存储过程 示例
-- 改回 mysql console结尾的 ;
DELIMITER ;

-- 随便定义一个变量 赋一个初始值
SET @r_result = -9999;
CALL execute_seckill(1003, 13810099014, now(), @r_result);

-- 获取结果
SELECT @r_result;

-- 存储过程总结
-- 1：存储过程优化：事务行级锁持有时间
-- 2：不要过度依赖存储过程（银行行业会大量使用存储过程 互联网公司不常用）
-- 3：简单的逻辑 可以应用存储过程（如 执行秒杀逻辑）
-- 4：QPS: 优化后可以达到 一个秒杀单 接近 6000/qps