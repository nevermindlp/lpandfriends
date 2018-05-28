package org.seckill.dao;

import org.apache.ibatis.annotations.Param;
import org.seckill.entity.SuccessKilled;

/**
 *
 * Dao: 数据访问对象层（存放数据库或者其他存储访问的类/接口）
 * Created by LW on 2018/5/15.
 */
public interface SuccessKilledDao {
    /**
     * 插入购买明细，可过滤重复秒杀（表结构 联合唯一主键）
     * @param seckillId
     * @param userPhone
     * @return 插入的行数（返回0代表插入失败）
     */
    int insertSuccessKilled(@Param("seckillId") long seckillId, @Param("userPhone") long userPhone);

    /**
     * 根据id查询SuccessKilled并携带秒杀商品对象实体
     * @param seckillId
     * @param userPhone
     * @return
     */
    SuccessKilled queryByIdWithSeckill(@Param("seckillId") long seckillId, @Param("userPhone") long userPhone);
}
