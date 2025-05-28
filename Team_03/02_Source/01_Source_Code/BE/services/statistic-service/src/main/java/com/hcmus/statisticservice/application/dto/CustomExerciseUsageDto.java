package com.hcmus.statisticservice.application.dto;

import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@Builder
@Getter
@Setter
public class CustomExerciseUsageDto {
    private String label;

    private Integer count;
}
