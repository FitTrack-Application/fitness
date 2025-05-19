package com.hcmus.exerciseservice.service;

import com.hcmus.exerciseservice.dto.ExerciseDto;
import com.hcmus.exerciseservice.dto.request.ExerciseRequest;
import com.hcmus.exerciseservice.dto.response.ApiResponse;
import com.hcmus.exerciseservice.dto.response.ExerciseCaloriesResponse;
import org.springframework.data.domain.Pageable;

import java.util.List;
import java.util.UUID;

public interface ExerciseService {
    ApiResponse<List<ExerciseDto>> getSystemExercises(Pageable pageable);

    ApiResponse<List<ExerciseDto>> searchSystemExerciseByName(String query, Pageable pageable);

    ApiResponse<List<ExerciseDto>> getExercisesByUserId(UUID userId, Pageable pageable);

    ApiResponse<List<ExerciseDto>> searchExercisesByUserIdAndName(UUID userId, String query, Pageable pageable);

    ApiResponse<ExerciseDto> getExerciseById(UUID exerciseId);

    ApiResponse<ExerciseDto> createExercise(ExerciseRequest exerciseRequest, UUID userId);

    ApiResponse<?> deleteExerciseByIdAndUserId(UUID exerciseId, UUID userId);

    ApiResponse<ExerciseCaloriesResponse> getExerciseCaloriesById(UUID exerciseId,  int duration);
}
