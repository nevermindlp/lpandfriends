package com.lw.domain;

import javax.persistence.*;

/**
 * Created by LW on 2018/7/4.
 */

@Entity
@Table(name = "test_lw_task")
public class Task {
    private Integer taskId;
    private String taskName;
    private Leader leader;

    public Task() {
    }

    public Task(String taskName) {
        this.taskName = taskName;
    }

    @GeneratedValue
    @Id
    public Integer getTaskId() {
        return taskId;
    }

    public void setTaskId(Integer taskId) {
        this.taskId = taskId;
    }

    public String getTaskName() {
        return taskName;
    }

    public void setTaskName(String taskName) {
        this.taskName = taskName;
    }

    @ManyToOne(cascade = CascadeType.ALL, fetch = FetchType.EAGER)
    @JoinColumn(name = "lid")
    public Leader getLeader() {
        return leader;
    }

    public void setLeader(Leader leader) {
        this.leader = leader;
    }

    @Override
    public String toString() {
        return "Task{" +
                "taskId=" + taskId +
                ", taskName='" + taskName + '\'' +
                '}';
    }
}
