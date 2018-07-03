package com.lw.entity;

import com.lw.custom.Column;
import com.lw.custom.Table;
import com.lw.pojo.Dog;
import lombok.Data;

/**
 * Created by LW on 2018/7/3.
 */
@Data
@Table("YellowDog")
public class YellowDog extends Dog {
    @Column(name = "color")
    private String color;
    @Column(name = "owner")
    private String owner;
}
