package com.hcmus.exerciseservice.mapper;

import com.hcmus.exerciseservice.dto.response.ExerciseLogEntryResponse;
import com.hcmus.exerciseservice.dto.response.ExerciseLogResponse;
import com.hcmus.exerciseservice.model.ExerciseLog;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.List;

@RequiredArgsConstructor
@Component
public class ExerciseLogMapper {

    private final ExerciseLogEntryMapper exerciseLogEntryMapper;

    public ExerciseLogResponse convertToExerciseLogResponse(ExerciseLog exerciseLog) {
        List<ExerciseLogEntryResponse> exerciseLogEntryResponses = exerciseLog.getExerciseLogEntries()
                .stream()
                .map(exerciseLogEntryMapper::convertToExerciseLogEntryResponse)
                .toList();

        return ExerciseLogResponse.builder()
                .id(exerciseLog.getExerciseLogId())
                .date(exerciseLog.getDate())
                .exerciseLogEntries(exerciseLogEntryResponses)
                .build();
    }
}
