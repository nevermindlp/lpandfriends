package com.lw.task;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Created by LW on 2018/6/13.
 */
@Component
public class TestTask {

    private static final SimpleDateFormat dateFormat = new SimpleDateFormat("HH:mm:ss");

    /**
     * 定义每隔三秒 执行任务
     */
//    @Scheduled(fixedRate = 3000)
    @Scheduled(cron = "6-9 * * * * ? ") // http://cron.qqe2.com/
    public void reportCurrentTime() {
        System.out.println("now: " + dateFormat.format(new Date()));
    }
}
