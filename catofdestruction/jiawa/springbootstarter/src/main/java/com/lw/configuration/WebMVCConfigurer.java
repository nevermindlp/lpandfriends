package com.lw.configuration;

import com.lw.controller.interceptor.OneInterceptor;
import com.lw.controller.interceptor.TwoInterceptor;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;

/**
 * Created by LW on 2018/6/13.
 */
@Configuration
public class WebMVCConfigurer extends WebMvcConfigurerAdapter {

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        /**
         * 拦截器 按照顺序执行
         */
        registry.addInterceptor(new OneInterceptor()).addPathPatterns("/one/**");
        registry.addInterceptor(new TwoInterceptor()).addPathPatterns("/two/**")
                .addPathPatterns("/one/**");

        super.addInterceptors(registry);
    }
}
