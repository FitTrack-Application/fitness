package com.hcmus.statisticservice.application.service;

import com.hcmus.statisticservice.application.dto.request.ExerciseRequest;
import com.hcmus.statisticservice.application.dto.request.FoodRequest;
import com.hcmus.statisticservice.application.dto.response.AdminReportResponse;
import com.hcmus.statisticservice.application.dto.response.ApiResponse;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.UUID;

@Service
public interface AdminReportService {
    ApiResponse<AdminReportResponse> getAdminReport();
    ApiResponse<?> importFood(List<FoodRequest> foodRequests);
    ApiResponse<?> importExercise(List<ExerciseRequest> exerciseRequests);
}
