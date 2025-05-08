package com.hcmus.exerciseservice.service;

import com.hcmus.exerciseservice.dto.ExerciseDto;
import com.hcmus.exerciseservice.dto.request.ExerciseRequest;
import com.hcmus.exerciseservice.dto.response.ApiResponse;
import com.hcmus.exerciseservice.dto.response.ExerciseCaloriesResponse;
import org.springframework.data.domain.Pageable;

import java.util.List;
import java.util.UUID;

public interface ExerciseService {
    ApiResponse<List<ExerciseDto>> getAllExercises(Pageable pageable);

    ApiResponse<List<ExerciseDto>> searchExerciseByName(String query, Pageable pageable);

    ApiResponse<ExerciseDto> getExerciseById(UUID exerciseId);

    ApiResponse<ExerciseDto> createExercise(ExerciseRequest exerciseRequest, UUID userId);

    ApiResponse<?> deleteExerciseById(UUID exerciseId);

    ApiResponse<ExerciseCaloriesResponse> getExerciseCaloriesById(UUID exerciseId,  int duration);
}
