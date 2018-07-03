package com.lw.entity;

import com.lw.custom.Column;
import com.lw.custom.Table;
import lombok.Data;

/**
 * Created by LW on 2018/7/3.
 */
@Data
@Table("Camera")
public class Camera {
    @Column(name = "id")
    private Integer id;
    @Column(name = "name")
    private String name;
    @Column(name = "location")
    private String location;
    @Column(name = "type")
    private String type;
}
