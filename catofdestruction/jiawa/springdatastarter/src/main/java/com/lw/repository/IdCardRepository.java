package com.lw.repository;

import com.lw.domain.IdCard;
import org.springframework.data.jpa.repository.JpaRepository;

/**
 * Created by LW on 2018/7/10.
 */
public interface IdCardRepository extends JpaRepository<IdCard, String> {
}
