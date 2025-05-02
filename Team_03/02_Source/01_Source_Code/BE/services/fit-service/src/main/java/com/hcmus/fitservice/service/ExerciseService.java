package com.hcmus.fitservice.service;

import com.hcmus.fitservice.dto.ExerciseDto;
import com.hcmus.fitservice.dto.request.ExerciseCaloriesRequest;
import com.hcmus.fitservice.dto.request.ExerciseRequest;
import com.hcmus.fitservice.dto.response.ApiResponse;
import com.hcmus.fitservice.dto.response.ExerciseCaloriesResponse;
import org.springframework.data.domain.Pageable;

import java.util.List;
import java.util.UUID;

public interface ExerciseService {
    ApiResponse<List<ExerciseDto>> getAllExercises(Pageable pageable);

    ApiResponse<List<ExerciseDto>> searchExerciseByName(String query, Pageable pageable);

    ApiResponse<ExerciseDto> getExerciseById(UUID exerciseId);

    ApiResponse<ExerciseDto> createExercise(ExerciseRequest exerciseRequest, UUID userId);

    ApiResponse<?> deleteExerciseById(UUID exerciseId);

    ApiResponse<ExerciseCaloriesResponse> getExerciseCaloriesById(UUID exerciseId, ExerciseCaloriesRequest exerciseCaloriesRequest);
}
