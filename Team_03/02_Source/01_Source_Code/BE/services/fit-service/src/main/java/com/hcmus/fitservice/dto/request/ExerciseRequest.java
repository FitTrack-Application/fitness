package com.hcmus.fitservice.dto.request;

import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
public class ExerciseRequest {

    private String name;

    private Integer duration;

    private Integer caloriesBurned;
}
