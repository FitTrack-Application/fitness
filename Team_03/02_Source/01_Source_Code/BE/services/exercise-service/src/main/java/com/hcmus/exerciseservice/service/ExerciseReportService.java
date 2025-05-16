package com.hcmus.exerciseservice.service;

import com.hcmus.exerciseservice.dto.response.ApiResponse;
import com.hcmus.exerciseservice.dto.response.ExerciseReportResponse;

import java.util.List;
import java.util.UUID;

public interface ExerciseReportService {
    ApiResponse<ExerciseReportResponse> getExerciseReport();
}
