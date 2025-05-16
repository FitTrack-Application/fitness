package com.hcmus.statisticservice.application.dto;

import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@Builder
@Getter
@Setter
public class CustomFoodUsageDto {
    private String label;

    private Integer count;
}
