package com.hcmus.exerciseservice.service;

import com.hcmus.exerciseservice.dto.request.ExerciseLogEntryRequest;
import com.hcmus.exerciseservice.dto.response.ApiResponse;
import com.hcmus.exerciseservice.dto.response.ExerciseLogEntryResponse;
import com.hcmus.exerciseservice.dto.response.TotalCaloriesBurnedResponse;

import java.util.UUID;

public interface ExerciseLogEntryService {

    ApiResponse<?> deleteExerciseLogEntryById(UUID exerciseLogEntryId);

    ApiResponse<ExerciseLogEntryResponse> updateExerciseLogEntryById(UUID exerciseLogEntryId, ExerciseLogEntryRequest exerciseLogEntryRequest);

    ApiResponse<TotalCaloriesBurnedResponse> getTotalCaloriesBurnedByUserId(UUID userId);

}
