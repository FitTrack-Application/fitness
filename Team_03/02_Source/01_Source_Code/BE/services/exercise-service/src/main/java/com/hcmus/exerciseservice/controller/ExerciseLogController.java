package com.hcmus.exerciseservice.controller;

import com.hcmus.exerciseservice.dto.request.ExerciseLogEntryRequest;
import com.hcmus.exerciseservice.dto.request.InitiateExerciseLogRequest;
import com.hcmus.exerciseservice.dto.response.ApiResponse;
import com.hcmus.exerciseservice.dto.response.ExerciseLogEntryResponse;
import com.hcmus.exerciseservice.dto.response.ExerciseLogResponse;
import com.hcmus.exerciseservice.service.ExerciseLogService;
import com.hcmus.exerciseservice.util.CustomSecurityContextHolder;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Date;
import java.util.UUID;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/exercise-logs")
public class ExerciseLogController {

    private final ExerciseLogService exerciseLogService;

    @PostMapping
    public ResponseEntity<ApiResponse<?>> createExerciseLog(@RequestBody InitiateExerciseLogRequest initiateExerciseLogRequest) {
        UUID userId = CustomSecurityContextHolder.getCurrentUserId();

        ApiResponse<?> response = exerciseLogService.createExerciseLog(initiateExerciseLogRequest, userId);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @PostMapping("/{exerciseLogId}/entries")
    public ResponseEntity<ApiResponse<ExerciseLogEntryResponse>> addExerciseLogEntry(
            @PathVariable UUID exerciseLogId,
            @RequestBody ExerciseLogEntryRequest exerciseLogEntryRequest
    ) {
        ApiResponse<ExerciseLogEntryResponse> response = exerciseLogService.addExerciseLogEntry(exerciseLogId, exerciseLogEntryRequest);

        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @GetMapping
    public ResponseEntity<ApiResponse<ExerciseLogResponse>> getExerciseLogByUserIdAndDate(
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date date
    ) {
        UUID userId = CustomSecurityContextHolder.getCurrentUserId();

        ApiResponse<ExerciseLogResponse> response = exerciseLogService.getExerciseLogByUserIdAndDate(userId, date);
        return ResponseEntity.ok(response);
    }
}
