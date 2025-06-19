package com.hcmus.exerciseservice.mapper;

import com.hcmus.exerciseservice.dto.response.ExerciseLogEntryResponse;
import com.hcmus.exerciseservice.model.ExerciseLogEntry;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

@RequiredArgsConstructor
@Component
public class ExerciseLogEntryMapper {

    private final ExerciseMapper exerciseMapper;

    public ExerciseLogEntryResponse convertToExerciseLogEntryResponse(ExerciseLogEntry exerciseLogEntry) {
        int caloriesBurned = exerciseLogEntry.getExercise().getCaloriesBurnedPerMinute() * exerciseLogEntry.getDuration();

        return ExerciseLogEntryResponse.builder()
                .id(exerciseLogEntry.getExerciseLogEntryId())
                .exercise(exerciseMapper.convertToExerciseDto(exerciseLogEntry.getExercise()))
                .duration(exerciseLogEntry.getDuration())
                .caloriesBurned(caloriesBurned)
                .build();
    }
}
