package com.lw.utils;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Lazy;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Component;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.JedisPoolConfig;

import java.util.Map;
import java.util.Set;
import java.util.concurrent.TimeUnit;

/**
 * 
 * @Title: RedisOperator.java
 * @Package com.itzixi.web.component
 * @Description: 使用redisTemplate的操作实现类 Copyright: Copyright (c) 2016
 *               Company:FURUIBOKE.SCIENCE.AND.TECHNOLOGY
 * 
 * @author leechenxiang
 * @date 2017年9月29日 下午2:25:03
 * @version V1.0
 */
@Component
@ConfigurationProperties(prefix = "spring.redis")
public class RedisOperator {

    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
	private StringRedisTemplate redisTemplate;

//    @Autowired
//    private RedisTemplate<String, Object> template;
	@Autowired
	private RedisProperties redisProperties;

	private String host;
	private int port;
	private int timeout;
	private int maxIdle;
	private long maxWaitMillis;

	public String getHost() {
		return host;
	}

	public void setHost(String host) {
		this.host = host;
	}

	public int getPort() {
		return port;
	}

	public void setPort(int port) {
		this.port = port;
	}

	public int getTimeout() {
		return timeout;
	}

	public void setTimeout(int timeout) {
		this.timeout = timeout;
	}

	public int getMaxIdle() {
		return maxIdle;
	}

	public void setMaxIdle(int maxIdle) {
		this.maxIdle = maxIdle;
	}

	public long getMaxWaitMillis() {
		return maxWaitMillis;
	}

	public void setMaxWaitMillis(long maxWaitMillis) {
		this.maxWaitMillis = maxWaitMillis;
	}

	@Autowired
	@Lazy
	// JedisPool 类似于数据库连接池的 ConnectionPool（Jedis 类似于数据库的Connection）
	private JedisPool jedisPool = redisPoolFactory();

	@Bean
	public JedisPool redisPoolFactory() {

		logger.info("JedisPool注入成功！！");
		logger.info("redis地址：" + host + ":" + port);
		JedisPoolConfig jedisPoolConfig = new JedisPoolConfig();
		jedisPoolConfig.setMaxIdle(maxIdle);
		jedisPoolConfig.setMaxWaitMillis(maxWaitMillis);

		JedisPool jedisPool = new JedisPool(jedisPoolConfig, host, port, timeout);

		return jedisPool;
	}

    // Key（键），简单的key-value操作

	/**
	 * 实现命令：TTL key，以秒为单位，返回给定 key的剩余生存时间(TTL, time to live)。
	 *
	 * @param key
	 * @return
	 */
	public long ttl(String key) {
		return redisTemplate.getExpire(key);
	}

	/**
	 * 实现命令：expire 设置过期时间，单位秒
	 *
	 * @param key
	 * @return
	 */
	public void expire(String key, long timeout) {
		redisTemplate.expire(key, timeout, TimeUnit.SECONDS);
	}

	/**
	 * 实现命令：INCR key，增加key一次
	 *
	 * @param key
	 * @return
	 */
	public long incr(String key, long delta) {
		return redisTemplate.opsForValue().increment(key, delta);
	}

	/**
	 * 实现命令：KEYS pattern，查找所有符合给定模式 pattern的 key
	 */
	public Set<String> keys(String pattern) {
		return redisTemplate.keys(pattern);
	}

	/**
	 * 实现命令：DEL key，删除一个key
	 *
	 * @param key
	 */
	public void del(String key) {
		redisTemplate.delete(key);
	}

	// String（字符串）

	/**
	 * 实现命令：SET key value，设置一个key-value（将字符串值 value关联到 key）
	 *
	 * @param key
	 * @param value
	 */
	public void set(String key, String value) {
		redisTemplate.opsForValue().set(key, value);
	}

	/**
	 * 实现命令：SET key value EX seconds，设置key-value和超时时间（秒）
	 *
	 * @param key
	 * @param value
	 * @param timeout
	 *            （以秒为单位）
	 */
	public void set(String key, String value, long timeout) {
		redisTemplate.opsForValue().set(key, value, timeout, TimeUnit.SECONDS);
	}

	/**
	 * 实现命令：GET key，返回 key所关联的字符串值。
	 *
	 * @param key
	 * @return value
	 */
	public String get(String key) {
		return (String)redisTemplate.opsForValue().get(key);
	}

	// Hash（哈希表）

	/**
	 * 实现命令：HSET key field value，将哈希表 key中的域 field的值设为 value
	 *
	 * @param key
	 * @param field
	 * @param value
	 */
	public void hset(String key, String field, Object value) {
		redisTemplate.opsForHash().put(key, field, value);
	}

	/**
	 * 实现命令：HGET key field，返回哈希表 key中给定域 field的值
	 *
	 * @param key
	 * @param field
	 * @return
	 */
	public String hget(String key, String field) {
		return (String) redisTemplate.opsForHash().get(key, field);
	}

	/**
	 * 实现命令：HDEL key field [field ...]，删除哈希表 key 中的一个或多个指定域，不存在的域将被忽略。
	 *
	 * @param key
	 * @param fields
	 */
	public void hdel(String key, Object... fields) {
		redisTemplate.opsForHash().delete(key, fields);
	}

	/**
	 * 实现命令：HGETALL key，返回哈希表 key中，所有的域和值。
	 *
	 * @param key
	 * @return
	 */
	public Map<Object, Object> hgetall(String key) {
		return redisTemplate.opsForHash().entries(key);
	}

	// List（列表）

	/**
	 * 实现命令：LPUSH key value，将一个值 value插入到列表 key的表头
	 *
	 * @param key
	 * @param value
	 * @return 执行 LPUSH命令后，列表的长度。
	 */
	public long lpush(String key, String value) {
		return redisTemplate.opsForList().leftPush(key, value);
	}

	/**
	 * 实现命令：LPOP key，移除并返回列表 key的头元素。
	 *
	 * @param key
	 * @return 列表key的头元素。
	 */
	public String lpop(String key) {
		return (String)redisTemplate.opsForList().leftPop(key);
	}

	/**
	 * 实现命令：RPUSH key value，将一个值 value插入到列表 key的表尾(最右边)。
	 *
	 * @param key
	 * @param value
	 * @return 执行 LPUSH命令后，列表的长度。
	 */
	public long rpush(String key, String value) {
		return redisTemplate.opsForList().rightPush(key, value);
	}


	public void setObj(String key, Object value, int timeout) {

        try {
            /**
             * jedis 依赖
             */
			System.out.println(redisProperties);

			Jedis jedis = jedisPool.getResource(); // Jedis 类似于数据库的Connection

            try {
                byte[] serializeBytes = ProtostuffUtil.serialize(value);

                // setex 为 jedis 的 超时缓存 策略， 如果缓存成功 返回String OK, 失败返回错误信息
                String result = jedis.setex(key.getBytes(), timeout, serializeBytes);
                System.out.println("setObj result: " + result);
            } finally {
                jedis.close(); // 关闭
            }
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
        }
	}

	public <T> T getObj(String key, Class clazz) {

        try {
            /**
             * jedis 依赖
             */
			Jedis jedis = jedisPool.getResource(); // Jedis 类似于数据库的Connection
            try {
                byte[] deserializeBytes = jedis.get(key.getBytes());
                T deserializeObj = ProtostuffUtil.deserialize(deserializeBytes);

                if (deserializeObj != null) { // 从缓存中获取到了
                    return deserializeObj;
                }
            } finally {
                jedis.close(); // 关闭
            }
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
        }

        return null;
	}


}