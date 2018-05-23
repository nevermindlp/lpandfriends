-- 数据库初始化脚本

-- 创建数据库
CREATE DATABASE seckill;
-- 使用数据库
USE seckill;
-- 创建秒杀库存表;
CREATE TABLE seckill(
seckill_id BIGINT NOT NULL AUTO_INCREMENT COMMENT '商品库存id',
name VARCHAR(120) NOT NULL COMMENT '商品名称',
number INT NOT NULL COMMENT '库存数量',
start_time TIMESTAMP NOT NULL COMMENT '秒杀开启时间',
end_time TIMESTAMP NOT NULL COMMENT '秒杀结束时间',
create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
PRIMARY KEY (seckill_id), /*主键*/
  KEY idx_start_time(start_time), /*其他索引 idx_start_time idx_end_time idx_create_time idx是index 缩写*/
  KEY idx_end_time(end_time), /*这些索引都是为了支持 将来加速查询*/
  KEY idx_create_time(create_time)
) ENGINE=InnoDB AUTO_INCREMENT=1000 DEFAULT CHARSET=utf8 COMMENT='秒杀库存表'; /* 只有InnoDB支持事务 显示声明 自增*/

-- 初始化数据
INSERT INTO
  seckill(name, number, start_time, end_time)
VALUES
  ('1000元秒杀iPhone 6', 100, '2015-11-01 00:00:00', '2015-11-02 00:00:00'),
  ('500元秒杀iPad 2', 200, '2015-11-01 00:00:00', '2015-11-02 00:00:00'),
  ('300元秒杀小米4', 300, '2015-11-01 00:00:00', '2015-11-02 00:00:00'),
  ('3000元秒杀iPhone X', 10, '2015-11-01 00:00:00', '2015-11-02 00:00:00');

-- 秒杀成功明细表（用来记录谁秒成功 以及 秒杀成功时间）
-- 用户登录认证相关的信息（不可能再做一个用户权限、登录相关的模块 采用用户电话 字段去表示）
CREATE TABLE success_killed(
seckill_id BIGINT NOT NULL COMMENT '秒杀商品id',
user_phone BIGINT NOT NULL COMMENT '用户手机号',
state TINYINT NOT NULL DEFAULT -1 COMMENT '状态标示: -1:无效 0:成功 1:已付款 2:已发货',
create_time TIMESTAMP NOT NULL COMMENT '创建时间',
PRIMARY KEY (seckill_id, user_phone), /*联合主键 因为同一个用户(user_phone) 只能对同一个秒杀库存中的商品做秒杀操作 这两个字段组成了
一个唯一性 可以作为主键 后面可以通过此对防止用户重复秒杀做过滤（一个用户对同一个商品不能够重复秒杀）*/
  KEY idx_create_time(create_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='秒杀成功明细表';

-- 连接数据库控制台
-- mysql -u root -p

-- 为什么手写DDL
-- schema.sql 记录每次上线的DLL修改, 上线操作不可能直接通过第三方工具连线上的数据库去改，
-- 需要把本次上线要改的内容告诉mysql 上线时 DBA（其他同事）可以进行review

-- 如:
-- 上线v1.1
ALTER TABLE seckill DROP INDEX idx_create_time, ADD INDEX idx_c_s(start_time, create_time);

-- 上线v1.2
-- ddl ...