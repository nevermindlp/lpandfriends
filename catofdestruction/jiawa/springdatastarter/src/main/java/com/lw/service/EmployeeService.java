package com.lw.service;

import com.lw.domain.Employee;
import com.lw.repository.EmplyeeCrudRepository;
import com.lw.repository.EmplyeeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.List;

/**
 * Created by LW on 2018/6/28.
 */
@Service
@Transactional
public class EmployeeService {

    @Autowired
    private EmplyeeRepository emplyeeRepository;

    @Autowired
    private EmplyeeCrudRepository emplyeeCrudRepository;

    @Transactional
    public void updateAgeById(Integer id, Integer age) {

        emplyeeRepository.updateAgeById(id, age);
    }

    @Transactional
    public void updateNameById(Integer id, String name) {

        emplyeeRepository.updateNameById(id, name);
    }

    @Transactional
    public void removeById(Integer id) {

        emplyeeRepository.removeById(id);
    }


    public void save(List<Employee> employees) {
        emplyeeCrudRepository.save(employees);
    }
}
