package com.hcmus.exerciseservice.service;

import com.hcmus.exerciseservice.dto.response.ApiResponse;
import com.hcmus.exerciseservice.dto.response.ExerciseReportResponse;

public interface ExerciseReportService {
    ApiResponse<ExerciseReportResponse> getExerciseReport();
}
