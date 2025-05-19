package com.hcmus.statisticservice.application.dto.response;

import lombok.*;

import java.util.Date;

@Setter
@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class StepLogResponse {

    private Integer steps;

    private Date date;
}
