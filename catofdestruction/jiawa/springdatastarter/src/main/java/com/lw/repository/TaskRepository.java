package com.lw.repository;

import com.lw.domain.Task;
import org.springframework.data.repository.PagingAndSortingRepository;

/**
 * Created by LW on 2018/7/11.
 */
public interface TaskRepository extends PagingAndSortingRepository<Task, Integer> {
}
