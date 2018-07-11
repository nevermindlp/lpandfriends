package com.lw.repository;

import com.lw.domain.Task;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;

/**
 * Created by LW on 2018/7/11.
 */
public class TaskRepositoryTest {

    /**
     * 应用程序上下文
     */
    private ApplicationContext context = null;
    private TaskRepository taskRepository = null;

    @Before
    public void setUp() throws Exception {
        context = new ClassPathXmlApplicationContext("beans-new.xml");
        taskRepository = context.getBean(TaskRepository.class);
        System.out.println("setup");
    }

    @After
    public void tearDown() throws Exception {
        context = null;
        System.out.println("tearDown");
    }

    @Test
    public void testTask() {

        PageRequest pageRequest = new PageRequest(0, 10);
        Page<Task> tasks = taskRepository.findAll(pageRequest);
        for (Task task : tasks) {
            System.out.println(task + "==>" + task.getLeader());

        }
    }
}