package org.seckill.web;

import org.seckill.dto.Exposer;
import org.seckill.dto.SeckillExecution;
import org.seckill.dto.SeckillResult;
import org.seckill.entity.Seckill;
import org.seckill.enums.SeckillStateEnum;
import org.seckill.exception.RepeatKillException;
import org.seckill.exception.SeckillCloseException;
import org.seckill.exception.SeckillException;
import org.seckill.service.SeckillService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.Date;
import java.util.List;

/**
 * Created by LW on 2018/5/21.
 */
@Controller // 类似于@Service @Component 目的就是把当前Controller放入spring容器中
@RequestMapping("/seckill") // url: 模块/资源/{id}/细分 如果资源可以直接的话 如 /seckill/list
public class SeckillController {

    private Logger logger = LoggerFactory.getLogger(this.getClass());
    @Autowired
    SeckillService seckillService;

    @RequestMapping(value = "list",
            method = RequestMethod.GET)
    public String list(Model model) {
        // Model 用来存放 渲染 list.jsp 的数据
        // list.jsp 提供了页面的模板
        // list.jsp + model = ModelAndView

        // 获取列表页
        List<Seckill> seckillList = seckillService.getSeckillList();
        model.addAttribute("list", seckillList);

        return "list"; //   /WEB-INF/jsp/"list".jsp
    }

    @RequestMapping(value = "/{seckillId}/detail",
            method = RequestMethod.GET)
    public String detail(@PathVariable("seckillId") Long seckillId, Model model) {
        if (seckillId == null) {
            return "redirect:/seckill/list";
        }

        Seckill seckill = seckillService.getById(seckillId);
        if (seckill == null) {
            return "forward:/seckill/list";
        }
        model.addAttribute("seckill", seckill);

        return "detail";  //    /WEB-INF/jsp/"detail".jsp
    }

    // ajax 接口 返回类型 json
    @RequestMapping(value = "/{seckillId}/exposer",
            method = RequestMethod.POST,
            produces = {"application/json;charset=UTF-8"}) // charset=UTF-8  解决中文乱码问题
    @ResponseBody // ResponseBody 注解：springMVC会尝试将 返回结果 封装成json
    public SeckillResult<Exposer> expseer(@PathVariable("seckillId") Long seckillId) {
        SeckillResult<Exposer> result;
        try {
            Exposer exposer = seckillService.exportSeckillUrl(seckillId);
            result = new SeckillResult<Exposer>(true, exposer);
        } catch (Exception e) {
            logger.info(e.getMessage(), e);
            result = new SeckillResult<Exposer>(false, e.getMessage());
        }
        return result;
    }

    @RequestMapping(value = "/{seckillId}/{md5}/execution",
            method = RequestMethod.POST,
            produces = {"application/json;charset=UTF-8"}) // charset=UTF-8  解决中文乱码问题
    @ResponseBody // ResponseBody 注解：springMVC会尝试将 返回结果 封装成json
    /**
     * 第三个参数 不是请求参数传递 而是从用户浏览器请求的Cookie中获取（简单的String代替登录模块）
     * 默认情况下  在发现request header中没有所要的 cookie killPhone 时  springMVC 会报错
     * 将 required 设置为false 使得cookie killPhone不是必须的 把 killPhone 的验证逻辑放在程序中进行
     */
    public SeckillResult<SeckillExecution> execute(@PathVariable("seckillId") Long seckillId,
                                                   @PathVariable("md5") String md5,
                                                   @CookieValue(value = "killPhone", required = false) Long phone) {
        SeckillResult<SeckillExecution> result;
        SeckillExecution seckillExecution;

        // 此处的验证也可以使用springMVC的验证信息 valid
        if (phone == null) {
            seckillExecution = new SeckillExecution(seckillId, SeckillStateEnum.UNREGISTERED);
            result = new SeckillResult<SeckillExecution>(true, seckillExecution);
        }
        try {
            seckillExecution = seckillService.executeSeckill(seckillId, phone, md5);
            result = new SeckillResult<SeckillExecution>(true, seckillExecution);
        }  catch (SeckillCloseException e1) {
            seckillExecution = new SeckillExecution(seckillId, SeckillStateEnum.END);
            result = new SeckillResult<SeckillExecution>(true, seckillExecution);
        } catch (RepeatKillException e2) {
            seckillExecution = new SeckillExecution(seckillId, SeckillStateEnum.REPEAT_KILL);
            result = new SeckillResult<SeckillExecution>(true, seckillExecution);
        } catch (SeckillException e) {
            logger.info(e.getMessage(), e);
            seckillExecution = new SeckillExecution(seckillId, SeckillStateEnum.INNER_ERROR);
            result = new SeckillResult<SeckillExecution>(true, seckillExecution);
        }
        return result;
    }

    @RequestMapping(value = "/time/now", method = RequestMethod.GET)
    @ResponseBody
    public SeckillResult<Long> time() {
        Date now = new Date();
        return new SeckillResult<Long>(true, now.getTime());
    }
}