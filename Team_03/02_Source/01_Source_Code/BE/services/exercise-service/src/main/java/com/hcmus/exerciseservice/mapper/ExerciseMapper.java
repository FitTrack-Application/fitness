package com.hcmus.exerciseservice.mapper;

import com.hcmus.exerciseservice.dto.ExerciseDto;
import com.hcmus.exerciseservice.model.Exercise;
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
