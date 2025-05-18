package com.hcmus.statisticservice.application.dto;

import lombok.*;

import java.util.Date;

@AllArgsConstructor
@NoArgsConstructor
@Builder
@Getter
@Setter
public class NewUsersByWeekDto {
    private Date date;

    private Integer count;
}
