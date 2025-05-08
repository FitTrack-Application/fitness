package com.hcmus.exerciseservice.service;

import com.hcmus.exerciseservice.dto.request.ExerciseLogEntryRequest;
import com.hcmus.exerciseservice.dto.request.InitiateExerciseLogRequest;
import com.hcmus.exerciseservice.dto.response.ApiResponse;
import com.hcmus.exerciseservice.dto.response.ExerciseLogEntryResponse;
import com.hcmus.exerciseservice.dto.response.ExerciseLogResponse;

import java.util.Date;
import java.util.UUID;

public interface ExerciseLogService {
    ApiResponse<?> createExerciseLog(InitiateExerciseLogRequest initiateExerciseLogRequest, UUID userId);

    ApiResponse<ExerciseLogEntryResponse> addExerciseLogEntry(UUID exerciseLogId, ExerciseLogEntryRequest exerciseLogEntryRequest);

    ApiResponse<ExerciseLogResponse> getExerciseLogByUserIdAndDate(UUID userId, Date date);
}
