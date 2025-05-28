package com.hcmus.statisticservice.application.dto;


import lombok.*;

import java.util.UUID;

@AllArgsConstructor
@NoArgsConstructor
@Builder
@Getter
@Setter
public class ExerciseDto {

    private UUID id;

    private String name;

    private Integer caloriesBurnedPerMinute;
}
