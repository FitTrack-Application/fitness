package com.hcmus.exerciseservice.dto.response;

import lombok.*;

import java.util.List;

import com.hcmus.exerciseservice.dto.TopExerciseDto;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
public class ExerciseReportResponse {
    private Integer totalExercise;

    private Integer usedCustomExercise;

    private Integer usedAvailableExercise;

    private List<TopExerciseDto> topExercises;
}