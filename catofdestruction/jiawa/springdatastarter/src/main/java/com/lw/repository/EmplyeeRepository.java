package com.lw.repository;

import com.lw.domain.Employee;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.Repository;
import org.springframework.data.repository.query.Param;

import java.util.List;

/**
 * Created by LW on 2018/6/28.
 */

//@RepositoryDefinition(domainClass = Employee.class, idClass = Integer.class)
public interface EmplyeeRepository extends Repository<Employee, Integer> {

    public Employee findByName(String name);

    // where name like ?% and age <?
    public List<Employee> findByNameStartingWithAndAgeLessThan(String name, Integer age);

    // where name like %? and age >?
    public List<Employee> findByNameEndingWithAndAgeGreaterThan(String name, Integer age);

    // where name in (?, ?....) or age <?
    public List<Employee> findByNameInOrAgeLessThan(List<String> name, Integer age);

    @Query(value = "select o from Employee o where id = (select max(id) from Employee t1)")
    Employee getByMaxId();

    @Query(value = "select o from Employee o where o.name=?1 and o.age=?2")
    List<Employee> queryWithParams1(String name, Integer age);

    @Query(value = "select o from Employee o where o.name=:name and o.age=:age")
    List<Employee> queryWithParams2(@Param("name") String name,
                                    @Param("age") Integer age);

    @Query(value = "select o from Employee o where o.name like %?1%")
    List<Employee> queryNameLike1(String name);

    @Query(value = "select o from Employee o where o.name like %:name%")
    List<Employee> queryNameLike2(@Param("name") String name);

    @Query(nativeQuery = true, value = "select count(1) from employee")
    long queryCount();

    @Modifying
    @Query("update Employee o set o.age = :age where o.id = :id")
    void updateAgeById(@Param("id") Integer id, @Param("age") Integer age);

    @Modifying
    @Query("update Employee o set o.name = :name where o.id = :id")
    void updateNameById(@Param("id") Integer id, @Param("name") String name);

    @Modifying
    @Query("delete from Employee o where o.id = :id")
    void removeById(@Param("id") Integer id);
}
