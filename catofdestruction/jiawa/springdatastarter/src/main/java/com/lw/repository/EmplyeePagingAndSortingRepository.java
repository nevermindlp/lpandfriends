package com.lw.repository;

import com.lw.domain.Employee;
import com.lw.domain.EmployeeMultiKeysClass;
import org.springframework.data.repository.PagingAndSortingRepository;

/**
 * Created by LW on 2018/6/29.
 */
public interface EmplyeePagingAndSortingRepository
        extends PagingAndSortingRepository<Employee, EmployeeMultiKeysClass> {
}
