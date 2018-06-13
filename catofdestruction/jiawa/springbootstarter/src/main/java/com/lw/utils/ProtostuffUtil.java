package com.lw.utils;

import io.protostuff.LinkedBuffer;
import io.protostuff.ProtostuffIOUtil;
import io.protostuff.Schema;
import io.protostuff.runtime.RuntimeSchema;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Created by LW on 2018/6/12.
 */

public class ProtostuffUtil {

    private static final Logger logger = LoggerFactory.getLogger(ProtostuffUtil.class);
    /**
     *
     * 序列化/反序列化对象包装类
     * 基于 Protostuff 进行序列化/反序列化。
     * Protostuff 是基于POJO进行序列化和反序列化操作。
     * 如果需要进行序列化/反序列化的对象不知道其类型，不能进行序列化/反序列化；
     * 比如Map、List、String、Enum等是不能进行正确的序列化/反序列化。
     * 因此需要映入一个包装类，把这些需要序列化/反序列化的对象放到这个包装类中。
     * 这样每次 Protostuff 都是对这个类进行序列化/反序列化,不会出现不能/不正常的操作出现
     *
     */
    public static class DataWrapper<T> {
        private T data;

        public static <T> DataWrapper<T> builder(T data) {
            DataWrapper<T> wrapper = new DataWrapper<T>();
            wrapper.setData(data);
            return wrapper;
        }

        public T getData() {
            return data;
        }
        public void setData(T data) {
            this.data = data;
        }
    }

    /**
     * 序列化/反序列化包装类 Schema 对象
     */
    private static final Schema WRAPPER_SCHEMA = RuntimeSchema.createFrom(DataWrapper.class);

    /**
     * 序列化对象
     *
     * @param obj 需要序列化的对象
     * @param <T> 序列化对象的类型
     * @return 序列化后的二进制数组
     */
    public static <T> byte[] serialize(T obj) {
        LinkedBuffer buffer = LinkedBuffer.allocate(LinkedBuffer.DEFAULT_BUFFER_SIZE);
        try {
            Object serializeObj = DataWrapper.builder(obj);
            return ProtostuffIOUtil.toByteArray(serializeObj, WRAPPER_SCHEMA, buffer);
        } catch (Exception e) {
            logger.error("序列化对象异常 [" + obj + "]", e);
            throw new IllegalStateException(e.getMessage(), e);
        } finally {
            buffer.clear();
        }
    }

    /**
     * 反序列化对象
     *
     * @param data 需要反序列化的二进制数组
     * @param <T> 反序列化后的对象类型
     * @return 反序列化后的对象
     */
    public static <T> T deserialize(byte[] data) {
        try {
            DataWrapper<T> wrapper = new DataWrapper<>();
            ProtostuffIOUtil.mergeFrom(data, wrapper, WRAPPER_SCHEMA);
            T deserializeObj = wrapper.getData();
            return deserializeObj;
        } catch (Exception e) {
            logger.error("反序列化对象异常 [" + data + "]", e);
            throw new IllegalStateException(e.getMessage(), e);
        }
    }
}
