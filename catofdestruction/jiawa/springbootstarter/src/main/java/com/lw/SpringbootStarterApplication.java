package com.lw;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.annotation.EnableScheduling;
import tk.mybatis.spring.annotation.MapperScan;

@SpringBootApplication
// 扫描mybatis mapper 包路径
@MapperScan("com.lw.mapper")
// 扫描 所有需要的包，包含一些自用的工具包 所在路径
@ComponentScan(basePackages = {"com.lw"})

// 开启定时任务
@EnableScheduling
// 开启异步任务
@EnableAsync
public class SpringbootStarterApplication {

	public static void main(String[] args) {
		SpringApplication.run(SpringbootStarterApplication.class, args);
	}
}
