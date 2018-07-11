package com.lw.domain;

import javax.persistence.*;
import java.util.Set;

/**
 * Created by LW on 2018/7/4.
 */
@Entity
@Table(name = "test_lw_leader")
public class Leader {

    private Integer leaderId;
    private String leaderName;

    // one to many
    private Set<Task> tasks;

    public Leader() {
    }

    public Leader(String name) {
        this.leaderName = name;
    }

    @GeneratedValue
    @Id
    public Integer getLeaderId() {
        return leaderId;
    }

    public void setLeaderId(Integer leaderId) {
        this.leaderId = leaderId;
    }

    public String getLeaderName() {
        return leaderName;
    }

    public void setLeaderName(String leaderName) {
        this.leaderName = leaderName;
    }

    @OneToMany(cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "lid")
    public Set<Task> getTasks() {
        return tasks;
    }

    public void setTasks(Set<Task> tasks) {
        this.tasks = tasks;
    }

    @Override
    public String toString() {
        return "Leader{" +
                "leaderId=" + leaderId +
                ", leaderName='" + leaderName + '\'' +
                // FIXME: 2018/7/11 failed to lazily initialize a collection of role: com.lw.domain.Leader.tasks, could not initialize proxy - no Session
//                ", tasks=" + tasks +
                '}';
    }
}
