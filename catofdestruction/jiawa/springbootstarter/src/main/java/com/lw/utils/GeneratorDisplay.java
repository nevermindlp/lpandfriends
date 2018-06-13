package com.lw.utils;

import org.mybatis.generator.api.MyBatisGenerator;
import org.mybatis.generator.config.Configuration;
import org.mybatis.generator.config.xml.ConfigurationParser;
import org.mybatis.generator.internal.DefaultShellCallback;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by LW on 2018/6/5.
 */
public class GeneratorDisplay {

    public void generator() throws Exception {

        List<String> warnings = new ArrayList<>();
        boolean overwrite = true;
        // 指定 逆向工程配置文件
        File configFile = new File("generatorConfig.xml");
        ConfigurationParser parser = new ConfigurationParser(warnings);
        Configuration configuration = parser.parseConfiguration(configFile);
        DefaultShellCallback callback = new DefaultShellCallback(overwrite);
        MyBatisGenerator myBatisGenerator = new MyBatisGenerator(configuration, callback, warnings);
        myBatisGenerator.generate(null);
    }

    public static void main(String[] args) throws Exception {
        try {
            GeneratorDisplay generatorSqlMap = new GeneratorDisplay();
            generatorSqlMap.generator();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
