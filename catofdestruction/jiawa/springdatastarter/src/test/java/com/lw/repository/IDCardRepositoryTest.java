package com.lw.repository;

import com.lw.domain.IdCard;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;

/**
 * Created by LW on 2018/7/4.
 */
public class IDCardRepositoryTest {

    /**
     * 应用程序上下文
     */
    private ApplicationContext context = null;
    private IdCardRepository idCardRepository = null;

    @Before
    public void setUp() throws Exception {
        context = new ClassPathXmlApplicationContext("beans-new.xml");
        idCardRepository = context.getBean(IdCardRepository.class);
        System.out.println("setup");
    }

    @After
    public void tearDown() throws Exception {
        context = null;
        System.out.println("tearDown");
    }

    @Test
    public void testIDCard() {

        PageRequest pageRequest = new PageRequest(0, 10);
        Page<IdCard> idCards = idCardRepository.findAll(pageRequest);
        for (IdCard idCard : idCards) {
            System.out.println(idCard + "==>" + idCard.getEmployee());
        }
    }
}