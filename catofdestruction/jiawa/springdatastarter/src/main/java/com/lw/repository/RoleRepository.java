package com.lw.repository;

import com.lw.domain.Role;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

/**
 * Created by LW on 2018/7/11.
 */
public interface RoleRepository extends JpaRepository<Role, Integer>,
                                        JpaSpecificationExecutor<Role> {
}
