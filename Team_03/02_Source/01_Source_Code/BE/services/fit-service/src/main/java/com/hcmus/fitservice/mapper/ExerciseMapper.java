package com.hcmus.fitservice.mapper;

import com.hcmus.fitservice.dto.ExerciseDto;
import com.hcmus.fitservice.model.Exercise;
import org.springframework.stereotype.Component;

@Component
public class ExerciseMapper {

    public ExerciseDto convertToExerciseDto(Exercise exercise) {
        return ExerciseDto.builder()
                .id(exercise.getExerciseId())
                .name(exercise.getExerciseName())
                .caloriesBurnedPerMinute(exercise.getCaloriesBurnedPerMinute())
                .build();
    }
}
