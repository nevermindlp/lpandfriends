package org.seckill.service;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.seckill.dto.Exposer;
import org.seckill.dto.SeckillExecution;
import org.seckill.entity.Seckill;
import org.seckill.exception.RepeatKillException;
import org.seckill.exception.SeckillCloseException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.List;

/**
 * Created by LW on 2018/5/18.
 */

@RunWith(SpringJUnit4ClassRunner.class) // 在junit启动时加载springIOC容器
@ContextConfiguration({"classpath:spring/spring-dao.xml",
        "classpath:spring/spring-service.xml"}) // 告诉junit spring配置文件的工程位置
public class SeckillServiceTest {

    private Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    SeckillService seckillService;

    @Test
    public void getSeckillList() throws Exception {
        List<Seckill> seckillList = seckillService.getSeckillList();
        logger.info(" seckillList= {}", seckillList);
    }

    @Test
    public void getById() throws Exception {
        long seckillId = 1000;
        Seckill seckill = seckillService.getById(seckillId);
        logger.info(" seckill= {}", seckill);
    }

    @Test
    public void exportSeckillUrl() throws Exception {
        long seckillId = 1003;
        Exposer exposer = seckillService.exportSeckillUrl(seckillId);
        logger.info(" exposer= {}", exposer);
        //  exposer= Exposer{exposed=true, md5='df23901c74f85b4c664d239b7123247e', seckillId=1003, now=0, start=0, end=0}
    }

    @Test
    // 先获取秒杀地址及 md5，然后执行秒杀，可重复执行
    // 注意集成测试的 业务覆盖完整性
    public void executeSeckill() throws Exception {
        long seckillId = 1003;
        long xyPhone = 13810099014L;

        Exposer exposer = seckillService.exportSeckillUrl(seckillId);
        if (exposer.isExposed()) { // 正在秒杀中
            logger.info(" 秒杀进行中。。。 exposer= {}", exposer);

            try {
                SeckillExecution seckillExecution = seckillService.executeSeckill(seckillId, xyPhone, exposer.getMd5());
                logger.info(" seckillExecution= {}", seckillExecution);
            } catch (RepeatKillException e) { // 重复秒杀
                logger.info(e.getMessage());
            }  catch (SeckillCloseException e) { // 库存为0结束
                logger.info(e.getMessage());
            }
        } else {
            logger.info(" 秒杀未开始 或 已结束 exposer= {}", exposer);
        }
    }

    @Test
    public void executeSeckillByProcedure() throws Exception {
        long seckillId = 1003;
        long xyPhone = 13810099017L;

        Exposer exposer = seckillService.exportSeckillUrl(seckillId);
        if (exposer.isExposed()) { // 正在秒杀中
            logger.info(" 秒杀进行中。。。 exposer= {}", exposer);

            SeckillExecution seckillExecution = seckillService.executeSeckillByProcedure(seckillId, xyPhone, exposer.getMd5());
            logger.info(" seckillExecution= {}", seckillExecution);
        } else {
            logger.info(" 秒杀未开始 或 已结束 exposer= {}", exposer);
        }
    }
}