package com.lw.task;

import org.springframework.scheduling.annotation.Async;
import org.springframework.scheduling.annotation.AsyncResult;
import org.springframework.stereotype.Component;

import java.util.concurrent.Future;

/**
 * Created by LW on 2018/6/13.
 */
@Component
public class AsyncTask {

    @Async
    public Future<Boolean> doTaskA() throws Exception {
        long start = System.currentTimeMillis();
        Thread.sleep(1000);
        long end = System.currentTimeMillis();

        System.out.println("Task A costs: " + (end - start) + "ms");
        return new AsyncResult<>(true);
    }

    @Async
    public Future<Boolean> doTaskB() throws Exception {
        long start = System.currentTimeMillis();
        Thread.sleep(700);
        long end = System.currentTimeMillis();

        System.out.println("Task B costs: " + (end - start) + "ms");
        return new AsyncResult<>(true);
    }

    @Async
    public Future<Boolean> doTaskC() throws Exception {
        long start = System.currentTimeMillis();
        Thread.sleep(600);
        long end = System.currentTimeMillis();

        System.out.println("Task C costs: " + (end - start) + "ms");
        return new AsyncResult<>(true);
    }
}
