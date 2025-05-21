package com.hcmus.exerciseservice.service;

import com.hcmus.exerciseservice.dto.request.ExerciseLogEntryRequest;
import com.hcmus.exerciseservice.dto.response.ApiResponse;
import com.hcmus.exerciseservice.dto.response.ExerciseLogEntryResponse;
import com.hcmus.exerciseservice.dto.response.TotalCaloriesBurnedResponse;
import com.hcmus.exerciseservice.exception.ResourceNotFoundException;
import com.hcmus.exerciseservice.mapper.ExerciseLogEntryMapper;
import com.hcmus.exerciseservice.model.Exercise;
import com.hcmus.exerciseservice.model.ExerciseLogEntry;
import com.hcmus.exerciseservice.repository.ExerciseLogEntryRepository;
import com.hcmus.exerciseservice.repository.ExerciseRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.UUID;

@RequiredArgsConstructor
@Service
public class ExerciseLogEntryServiceImpl implements ExerciseLogEntryService {

    private final ExerciseLogEntryRepository exerciseLogEntryRepository;

    private final ExerciseRepository exerciseRepository;

    private final ExerciseLogEntryMapper exerciseLogEntryMapper;

    @Override
    public ApiResponse<?> deleteExerciseLogEntryById(UUID exerciseLogEntryId) {
        ExerciseLogEntry exerciseLogEntry = exerciseLogEntryRepository.findById(exerciseLogEntryId)
                .orElseThrow(() -> new ResourceNotFoundException("Exercise log entry not found"));

        exerciseLogEntryRepository.delete(exerciseLogEntry);

        return ApiResponse.builder()
                .status(200)
                .generalMessage("Successfully deleted exercise log entry")
                .build();
    }


    @Override
    public ApiResponse<ExerciseLogEntryResponse> updateExerciseLogEntryById(UUID exerciseLogEntryId, ExerciseLogEntryRequest exerciseLogEntryRequest) {
        ExerciseLogEntry exerciseLogEntry = exerciseLogEntryRepository.findById(exerciseLogEntryId)
                .orElseThrow(() -> new ResourceNotFoundException("Exercise log entry not found"));

        Exercise exercise = exerciseRepository.findById(exerciseLogEntryRequest.getExerciseId())
                .orElseThrow(() -> new ResourceNotFoundException("Exercise not found"));

        // Update Exercise log entry
        exerciseLogEntry.setExercise(exercise);
        exerciseLogEntry.setDuration(exerciseLogEntryRequest.getDuration());

        exerciseLogEntryRepository.save(exerciseLogEntry);

        // Convert to Dto
        ExerciseLogEntryResponse exerciseLogEntryResponse = exerciseLogEntryMapper.convertToExerciseLogEntryResponse(exerciseLogEntry);

        return ApiResponse.<ExerciseLogEntryResponse>builder()
                .status(200)
                .generalMessage("Successfully updated exercise log entry")
                .data(exerciseLogEntryResponse)
                .build();
    }

    @Override
    public ApiResponse<TotalCaloriesBurnedResponse> getTotalCaloriesBurnedByUserId(UUID userId){
        Integer totalCaloriesBurned = exerciseLogEntryRepository.getTotalCaloriesBurnedByUserId(userId);
        if (totalCaloriesBurned == null) {
            totalCaloriesBurned = 0;
        }

        TotalCaloriesBurnedResponse response = TotalCaloriesBurnedResponse.builder()
                .totalCaloriesBurned(totalCaloriesBurned)
                .build();

        return ApiResponse.<TotalCaloriesBurnedResponse>builder()
                .status(200)
                .generalMessage("Successfully retrieved total calories burned")
                .data(response)
                .build();
    }
}
