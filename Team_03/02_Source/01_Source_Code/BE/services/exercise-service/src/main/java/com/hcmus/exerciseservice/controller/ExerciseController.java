package com.hcmus.exerciseservice.controller;

import com.hcmus.exerciseservice.dto.ExerciseDto;
import com.hcmus.exerciseservice.dto.request.ExerciseRequest;
import com.hcmus.exerciseservice.dto.response.ApiResponse;
import com.hcmus.exerciseservice.service.ExerciseService;
import com.hcmus.exerciseservice.util.CustomSecurityContextHolder;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/exercises")
public class ExerciseController {

    private final ExerciseService exerciseService;

    @GetMapping
    public ResponseEntity<ApiResponse<List<ExerciseDto>>> getExercises(
            @RequestParam(required = false) String query,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size
    ) {
        // Check if page and size are valid
        if (page < 1) {
            throw new IllegalArgumentException("Page number must be greater than 0");
        }
        if (size < 1) {
            throw new IllegalArgumentException("Size must be greater than 0");
        }

        Pageable pageable = PageRequest.of(page - 1, size);
        ApiResponse<List<ExerciseDto>> response;
        if (query == null || query.isEmpty()) {
            response = exerciseService.getAllExercises(pageable);
        } else {
            response = exerciseService.searchExerciseByName(query, pageable);
        }
        return ResponseEntity.ok(response);
    }

    @GetMapping("/{exerciseId}")
    public ResponseEntity<ApiResponse<ExerciseDto>> getExerciseById(@PathVariable UUID exerciseId) {
        ApiResponse<ExerciseDto> response = exerciseService.getExerciseById(exerciseId);
        return ResponseEntity.ok(response);
    }

    @PostMapping
    public ResponseEntity<ApiResponse<ExerciseDto>> createExercise(@RequestBody ExerciseRequest exerciseRequest) {
        UUID userId = CustomSecurityContextHolder.getCurrentUserId();

        ApiResponse<ExerciseDto> response = exerciseService.createExercise(exerciseRequest, userId);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @DeleteMapping("/{exerciseId}")
    public ResponseEntity<ApiResponse<?>> deleteExerciseById(@PathVariable UUID exerciseId) {
        ApiResponse<?> response = exerciseService.deleteExerciseById(exerciseId);

        return ResponseEntity.ok(response);
    }

    @GetMapping("/{exerciseId}/calories")
    public ResponseEntity<ApiResponse<?>> getExerciseCaloriesById(
            @PathVariable UUID exerciseId,
            @RequestParam int duration
    ) {
        // Check if duration is valid
        if (duration < 1) {
            throw new IllegalArgumentException("Duration must be greater than 0");
        }

        ApiResponse<?> response = exerciseService.getExerciseCaloriesById(exerciseId, duration);
        return ResponseEntity.ok(response);
    }
}
