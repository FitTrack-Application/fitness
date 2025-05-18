package com.hcmus.statisticservice.application.service;

import com.hcmus.statisticservice.application.dto.request.ExerciseRequest;
import com.hcmus.statisticservice.application.dto.request.FoodRequest;
import com.hcmus.statisticservice.application.dto.response.AdminReportResponse;
import com.hcmus.statisticservice.application.dto.response.ApiResponse;

import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface AdminReportService {
    ApiResponse<AdminReportResponse> getAdminReport();

    ApiResponse<?> importFood(List<FoodRequest> foodRequests);
    
    ApiResponse<?> importExercise(List<ExerciseRequest> exerciseRequests);
}
