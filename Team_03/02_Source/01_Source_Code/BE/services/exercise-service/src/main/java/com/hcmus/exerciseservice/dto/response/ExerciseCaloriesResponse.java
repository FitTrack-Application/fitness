package com.hcmus.exerciseservice.dto.response;

import lombok.*;

import java.util.UUID;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
public class ExerciseCaloriesResponse {

    private UUID id;

    private String name;

    private Integer duration;

    private Integer caloriesBurned;
}
