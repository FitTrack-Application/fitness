package com.hcmus.exerciseservice.controller;

import com.hcmus.exerciseservice.dto.request.ExerciseLogEntryRequest;
import com.hcmus.exerciseservice.dto.response.ApiResponse;
import com.hcmus.exerciseservice.dto.response.ExerciseLogEntryResponse;
import com.hcmus.exerciseservice.dto.response.TotalCaloriesBurnedResponse;
import com.hcmus.exerciseservice.service.ExerciseLogEntryService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/exercise-log-entries")
public class ExerciseLogEntryController {

    private final ExerciseLogEntryService exerciseLogEntryService;

    @DeleteMapping("/{exerciseLogEntryId}")
    public ResponseEntity<ApiResponse<?>> deleteExerciseLogEntryById(
            @PathVariable UUID exerciseLogEntryId
    ) {
        ApiResponse<?> response = exerciseLogEntryService.deleteExerciseLogEntryById(exerciseLogEntryId);
        return ResponseEntity.ok(response);
    }

    @PutMapping("/{exerciseLogEntryId}")
    public ResponseEntity<ApiResponse<ExerciseLogEntryResponse>> updateExerciseLogEntryById(
            @PathVariable UUID exerciseLogEntryId,
            @RequestBody ExerciseLogEntryRequest exerciseLogEntryRequest
    ) {
        ApiResponse<ExerciseLogEntryResponse> response = exerciseLogEntryService.updateExerciseLogEntryById(exerciseLogEntryId, exerciseLogEntryRequest);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/total-calories-burned/{userId}")
    public ResponseEntity<ApiResponse<TotalCaloriesBurnedResponse>> getTotalCaloriesBurnedByUserId(
            @PathVariable UUID userId
    ) {
        ApiResponse<TotalCaloriesBurnedResponse> response = exerciseLogEntryService.getTotalCaloriesBurnedByUserId(userId);
        return ResponseEntity.ok(response);
    }
}
