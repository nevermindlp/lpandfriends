package com.lw.repository;

import com.lw.domain.Employee;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

/**
 * Created by LW on 2018/6/29.
 */
public interface EmployeeJpaSpecificationExecutorRepository
        extends JpaRepository<Employee, Integer/*EmployeeMultiKeysClass*/>,
                JpaSpecificationExecutor<Employee> {
}
