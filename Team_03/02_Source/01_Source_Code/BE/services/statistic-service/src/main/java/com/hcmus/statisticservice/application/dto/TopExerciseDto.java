package com.hcmus.statisticservice.application.dto;

import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@Builder
@Getter
@Setter
public class TopExerciseDto {
    private String name;

    private Integer count;
}
