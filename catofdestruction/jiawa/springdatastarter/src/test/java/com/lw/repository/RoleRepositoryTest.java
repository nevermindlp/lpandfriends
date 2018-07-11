package com.lw.repository;

import com.lw.domain.Employee;
import com.lw.domain.Role;
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

import javax.persistence.criteria.*;
import java.util.List;

/**
 * Created by LW on 2018/7/11.
 */
public class RoleRepositoryTest {

    /**
     * 应用程序上下文
     */
    private ApplicationContext context = null;
    private RoleRepository roleRepository = null;

    /**
     * 通过Junit 中的 @Before 注解 在setup方法中 初始化 ApplicationContext
     */
    @Before
    public void setup() {
        context = new ClassPathXmlApplicationContext("beans-new.xml");
        roleRepository = context.getBean(RoleRepository.class);
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

        Specification<Role> roleSpecification = (root, query, cb) -> {

            Join<Employee, Role> join = root.join("employees", JoinType.LEFT);
            Path<Object> objectPath = join.get("age");

            Predicate predicate = cb.equal(objectPath, 99);
            return predicate;
        };

        Sort.Order order = new Sort.Order(Sort.Direction.DESC, "roleId");
        Sort sort = new Sort(order);

        Pageable pageable = new PageRequest(0, 8, sort);
        Page<Role> page = roleRepository.findAll(roleSpecification, pageable);

        System.out.println(page.getNumber() + 1 + " of " + page.getTotalPages() +
                " Total:" + page.getTotalElements());
        System.out.println("show count: " + page.getNumberOfElements());
        List<Role> content = page.getContent();
        content.forEach(employee -> {
            System.out.println(employee);
        });
    }
}