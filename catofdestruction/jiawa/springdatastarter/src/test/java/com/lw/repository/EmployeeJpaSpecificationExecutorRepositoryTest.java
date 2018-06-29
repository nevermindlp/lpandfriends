package com.lw.repository;

import com.lw.domain.Employee;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;

import javax.persistence.criteria.Path;
import javax.persistence.criteria.Predicate;
import java.util.List;

/**
 * Created by LW on 2018/6/29.
 */
public class EmployeeJpaSpecificationExecutorRepositoryTest {

    /**
     * 应用程序上下文
     */
    private ApplicationContext context = null;
    private EmployeeJpaSpecificationExecutorRepository employeeJpaSpecificationExecutorRepository = null;

    /**
     * 通过Junit 中的 @Before 注解 在setup方法中 初始化 ApplicationContext
     */
    @Before
    public void setup() {
        context = new ClassPathXmlApplicationContext("beans-new.xml");
        employeeJpaSpecificationExecutorRepository
                = context.getBean(EmployeeJpaSpecificationExecutorRepository.class);
        System.out.println("setup");
    }

    /**
     * 测试完成后销毁资源
     */
    @After
    public void tearDown() {
        context = null;
        System.out.println("tearDown");
    }

    @Test
    public void testPageAndSort() {

        Specification<Employee> specification = (root, query, cb) -> {
            Path path = root.get("age");
            Predicate predicate = cb.gt(path, 52);
            return predicate;
        };

        Sort.Order order = new Sort.Order(Sort.Direction.DESC, "id");
        Sort sort = new Sort(order);

        Pageable pageable = new PageRequest(0, 20, sort);
        Page<Employee> page = employeeJpaSpecificationExecutorRepository.findAll(specification, pageable);

        System.out.println(page.getNumber() + 1 + " of " + page.getTotalPages() +
                " Total:" + page.getTotalElements());
        System.out.println("show count: " + page.getNumberOfElements());
        List<Employee> content = page.getContent();
        content.forEach(employee -> {
            System.out.println(employee);
        });
    }
}
