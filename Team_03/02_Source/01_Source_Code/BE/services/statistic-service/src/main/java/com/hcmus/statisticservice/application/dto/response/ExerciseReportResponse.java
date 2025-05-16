package com.hcmus.statisticservice.application.dto.response;

import lombok.*;

import java.util.List;

import com.hcmus.statisticservice.application.dto.TopExerciseDto;

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