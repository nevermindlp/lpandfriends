package org.seckill.dao.cache;

import com.dyuproject.protostuff.LinkedBuffer;
import com.dyuproject.protostuff.ProtobufIOUtil;
import com.dyuproject.protostuff.runtime.RuntimeSchema;
import org.seckill.entity.Seckill;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;

/**
 *
 * Dao: 数据访问对象层（存放数据库或者其他存储访问的类/接口）
 * Created by LW on 2018/5/24.
 */
public class RedisDao {

    private Logger logger = LoggerFactory.getLogger(this.getClass());

    private final JedisPool jedisPool; // JedisPool 类似于数据库连接池的 ConnectionPool（Jedis 类似于数据库的Connection）

    /**
     * Google 的 protobuffer 需要自己配置schema
     *
     * protostuff 动态的 生成 schema （通过反射  Seckill.class）
     */
    private RuntimeSchema<Seckill> schema = RuntimeSchema.createFrom(Seckill.class);

    public RedisDao(String ip, int port) {
        this.jedisPool = new JedisPool(ip, port);
    }

    /**
     * 从Redis中获取 Seckill对象
     *  get: byte[] -> 反序列化 -> Object（Seckill）
     *
     * @param seckillId
     * @return
     */
    public Seckill getSeckill(long seckillId) {

        // Redis缓存的 存取对象操作（数据访问层的逻辑） 应该放在此dao层
        // 而不应该混入Service层
        try {
            /**
             * jedis 依赖
             */
            Jedis jedis = jedisPool.getResource(); // Jedis 类似于数据库的Connection
            try {
                String key = this.cacheSeckillKey(seckillId);
                // Redis/Jedis 并没有实现内部序列化/反序列化操作 需要手动实现 get -> byte[] -> 反序列化 -> Object
                // 可以使用 JDK 的序列化机制(即：Seckill implements Serializable + array ObjectOutputStream写成二进制数组) 但效率较低
                // 参考：https://github.com/eishay/jvm-serializers/wiki (Java序列化技术性能对比)
                // 最终选用 Google 的 protobuffer (protobuffer 需要自己配置schema)
                // 开源社区 写了一个api 更简便 的 protostuff   序列化过程 更加高效（速度快 转化对象空间小 即序列化后的字节数更小）

                // 采用自定义序列化方式 protostuff
                // 根据 schema 赋予相应的值（序列化的本质 通过字节码 及其 字节码对应 对象属性，将字节码数据 传递给属性）

                // 反序列化 protostuff : pojo.
                byte[] bytes = jedis.get(key.getBytes()); // 从Redis缓存中 获取 字节数组，通过 protostuff 反序列化
                if (bytes != null) { // 从缓存中获取到了

                    // 创建一个Seckill空对象 用于从字节数组 接收数据 把数据传递进空对象 完成反序列化
                    Seckill seckill = this.schema.newMessage();
                    ProtobufIOUtil.mergeFrom(bytes, seckill, this.schema); // 比原生JDK序列化 空间压缩到1/5 压缩速度两个数量级 且 节省CPU

                    // seckill 已被反序列化  类似于C语言的 传引用方式
                    return seckill;
                }

            } finally {
                jedis.close(); // 关闭
            }
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
        }

        return null;
    }

    /**
     *
     * 将 Seckill对象存入 Redis
     *  set: Object（Seckill） -> 序列化 -> byte[]
     *
     * @param seckill
     * @return
     */
    public String putSeckill(Seckill seckill) {

        try {

            Jedis jedis = jedisPool.getResource(); // Jedis 类似于数据库的Connection
            try {
                String key = this.cacheSeckillKey(seckill.getSeckillId());

                // 使用 protostuff 将 Seckill对象 序列化到 二进制数组
                // 第三个参数 为protostuff提供缓冲器 使用默认大小， 作用是在对象过大时 会进行缓冲过程
                byte[] bytes = ProtobufIOUtil.toByteArray(seckill, this.schema,
                                                            LinkedBuffer.allocate(LinkedBuffer.DEFAULT_BUFFER_SIZE));

                int timeout = 60 * 60; // 缓存一小时
                // setex 为 jedis 的 超时缓存 策略， 如果缓存成功 返回String OK, 失败返回错误信息
                String result = jedis.setex(key.getBytes(), timeout, bytes);
                return result;

            } finally {
                jedis.close(); // 关闭
            }
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
        }

        return null;
    }

    private String cacheSeckillKey(long seckillId) {
        return "seckill:" + seckillId;
    }
}
