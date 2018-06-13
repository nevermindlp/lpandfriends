package com.lw.controller;

import com.lw.pojo.JSONResult;
import com.lw.task.AsyncTask;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.concurrent.Future;

/**
 * Created by LW on 2018/6/13.
 */
@RestController
@RequestMapping("tasks")
public class DoTaskController {

    @Autowired
    private AsyncTask asyncTask;

    @RequestMapping(value = "testTask")
    public JSONResult testTask() throws Exception {

        long start = System.currentTimeMillis();

        Future<Boolean> taskA = asyncTask.doTaskA();
        Future<Boolean> taskB = asyncTask.doTaskB();
        Future<Boolean> taskC = asyncTask.doTaskC();

        while (!taskA.isDone() || !taskB.isDone() || !taskC.isDone()) {

            if (taskA.isDone() && taskB.isDone() && taskC.isDone()) {
                break;
            }
        }

        long end = System.currentTimeMillis();

        String timeCost = "Total tasks cost: " + (end - start) + "ms";
        System.out.println(timeCost);

        return JSONResult.success(timeCost);
    }
}
