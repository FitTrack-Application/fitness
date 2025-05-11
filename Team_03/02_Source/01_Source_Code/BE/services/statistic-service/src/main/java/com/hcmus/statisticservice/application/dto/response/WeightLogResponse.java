package com.hcmus.statisticservice.application.dto.response;

import lombok.*;

import java.time.LocalDate;

@Setter
@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class WeightLogResponse {

    private Double weight;

    private LocalDate date;
}
