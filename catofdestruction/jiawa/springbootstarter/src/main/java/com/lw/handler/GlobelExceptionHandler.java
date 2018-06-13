package com.lw.handler;

import com.lw.pojo.JSONResult;
import org.apache.catalina.servlet4preview.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

/**
 * Created by LW on 2018/6/4.
 */

@ControllerAdvice
public class GlobelExceptionHandler {

    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    private static final String ERROR_VIEW = "error";

//    @ExceptionHandler(value = Exception.class)
//    @ResponseBody
//    public Object errorException(HttpServletRequest request, Exception e) {
////        if (e instanceof GirlException) {
////            GirlException girlException = (GirlException) e;
////            return ResultUitl.error(girlException.getCode(), girlException.getMessage());
////        } else {
////            logger.error("system error={}", e.getMessage());
////            logger.error("===>", e);
////
////            return ResultUitl.error(GirlEnum.UNKNOWN_ERROR.getCode(), GirlEnum.UNKNOWN_ERROR.getMsg());
////        }
//        e.printStackTrace();
//
//        ModelAndView modelAndView = new ModelAndView();
//        modelAndView.addObject("exception111", e);
//        modelAndView.addObject("url", request.getRequestURL());
//        modelAndView.setViewName(ERROR_VIEW);
//
//        return modelAndView;
//    }

    @ExceptionHandler(value = Exception.class)
    @ResponseBody
    public JSONResult jsonException(HttpServletRequest request, Exception e) {
        return JSONResult.errorException(e.getMessage());
    }
}