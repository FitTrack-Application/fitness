package com.hcmus.exerciseservice.service;

import com.hcmus.exerciseservice.dto.ExerciseDto;
import com.hcmus.exerciseservice.dto.request.ExerciseRequest;
import com.hcmus.exerciseservice.dto.response.ApiResponse;
import com.hcmus.exerciseservice.dto.response.ExerciseCaloriesResponse;
import com.hcmus.exerciseservice.exception.ResourceNotFoundException;
import com.hcmus.exerciseservice.mapper.ExerciseMapper;
import com.hcmus.exerciseservice.model.Exercise;
import com.hcmus.exerciseservice.repository.ExerciseRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@RequiredArgsConstructor
@Service
public class ExerciseServiceImpl implements ExerciseService{

    private final ExerciseRepository exerciseRepository;

    private final ExerciseMapper exerciseMapper;

    // Helper method to build ApiResponse for exercise list
    private ApiResponse<List<ExerciseDto>> buildExerciseListResponse(Page<Exercise> exercisePage) {
        // Pagination info
        Map<String, Object> pagination = new HashMap<>();
        pagination.put("currentPage", exercisePage.getNumber() + 1); // Page number start at 1
        pagination.put("totalPages", exercisePage.getTotalPages());
        pagination.put("totalItems", exercisePage.getTotalElements());
        pagination.put("pageSize", exercisePage.getSize());

        Map<String, Object> metadata = new HashMap<>();
        metadata.put("pagination", pagination);

        Page<ExerciseDto> exercisePageDto = exercisePage.map(exerciseMapper::convertToExerciseDto);

        // Create response
        return ApiResponse.<List<ExerciseDto>>builder()
                .status(200)
                .generalMessage("Successfully retrieved exercises")
                .data(exercisePageDto.getContent())
                .metadata(metadata)
                .timestamp(LocalDateTime.now())
                .build();
    }

    @Override
    public ApiResponse<List<ExerciseDto>> getAllExercises(Pageable pageable) {
        Page<Exercise> exercisePage = exerciseRepository.findAll(pageable);

        return buildExerciseListResponse(exercisePage);
    }

    @Override
    public ApiResponse<List<ExerciseDto>> searchExerciseByName(String query, Pageable pageable) {
        Page<Exercise> exercisePage = exerciseRepository.findByExerciseNameContainingIgnoreCase(query, pageable);

        return buildExerciseListResponse(exercisePage);
    }

    @Override
    public ApiResponse<ExerciseDto> getExerciseById(UUID exerciseId) {
        Exercise exercise = exerciseRepository.findById(exerciseId)
                .orElseThrow(() -> new ResourceNotFoundException("Exercise not found with ID: " + exerciseId));

        ExerciseDto exerciseDto = exerciseMapper.convertToExerciseDto(exercise);

        return ApiResponse.<ExerciseDto>builder()
                .status(200)
                .generalMessage("Successfully retrieved exercise")
                .data(exerciseDto)
                .timestamp(LocalDateTime.now())
                .build();
    }

    @Override
    public ApiResponse<ExerciseDto> createExercise(ExerciseRequest exerciseRequest, UUID userId) {
        // Create new exercise
        Exercise exercise = new Exercise();
        exercise.setExerciseName(exerciseRequest.getName());

        int caloriesBurnedPerMinute = (int) Math.round(
                (double) exerciseRequest.getCaloriesBurned() / exerciseRequest.getDuration()
        );
        exercise.setCaloriesBurnedPerMinute(caloriesBurnedPerMinute);
        exercise.setUserId(userId);

        Exercise savedExercise = exerciseRepository.save(exercise);

        // Convert to Dto
        ExerciseDto exerciseDto = exerciseMapper.convertToExerciseDto(savedExercise);

        return ApiResponse.<ExerciseDto>builder()
                .status(201)
                .generalMessage("Successfully created exercise")
                .data(exerciseDto)
                .timestamp(LocalDateTime.now())
                .build();
    }

    @Override
    public ApiResponse<?> deleteExerciseById(UUID exerciseId) {
        // Find the exercise by id
        Exercise exercise = exerciseRepository.findById(exerciseId)
                .orElseThrow(() -> new ResourceNotFoundException("Exercise not found with ID: " + exerciseId));

        // Delete the exercise
        exerciseRepository.delete(exercise);

        return ApiResponse.builder()
                .status(200)
                .generalMessage("Successfully deleted exercise")
                .timestamp(LocalDateTime.now())
                .build();
    }

    @Override
    public ApiResponse<ExerciseCaloriesResponse> getExerciseCaloriesById(UUID exerciseId,  int duration) {
        // Find the exercise by id
        Exercise exercise = exerciseRepository.findById(exerciseId)
                .orElseThrow(() -> new ResourceNotFoundException("Exercise not found with ID: " + exerciseId));

        // Calculate calories burned
        int caloriesBurned = exercise.getCaloriesBurnedPerMinute() * duration;

        // Create response
        ExerciseCaloriesResponse response = new ExerciseCaloriesResponse();
        response.setId(exerciseId);
        response.setName(exercise.getExerciseName());
        response.setDuration(duration);
        response.setCaloriesBurned(caloriesBurned);

        return ApiResponse.<ExerciseCaloriesResponse>builder()
                .status(200)
                .generalMessage("Successfully retrieved exercise calories")
                .data(response)
                .timestamp(LocalDateTime.now())
                .build();
    }
}
