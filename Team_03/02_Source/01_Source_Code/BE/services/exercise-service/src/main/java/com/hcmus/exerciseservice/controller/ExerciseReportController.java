package com.hcmus.exerciseservice.controller;

import com.hcmus.exerciseservice.dto.response.ApiResponse;
import com.hcmus.exerciseservice.dto.response.ExerciseReportResponse;
import com.hcmus.exerciseservice.service.ExerciseReportService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/exercise-reports")
public class ExerciseReportController {

    private final ExerciseReportService exerciseReportService;

    @GetMapping
    public ResponseEntity<ApiResponse<ExerciseReportResponse>> getExerciseReport() {
        ApiResponse<ExerciseReportResponse> response = exerciseReportService.getExerciseReport();
        return ResponseEntity.ok(response);
    }


}
