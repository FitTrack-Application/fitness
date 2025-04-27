package com.hcmus.statisticservice.dto.response;

import lombok.*;

import java.util.Date;

@Setter
@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class WeightLogResponse {

    private Double weight;

    private Date date;
}
