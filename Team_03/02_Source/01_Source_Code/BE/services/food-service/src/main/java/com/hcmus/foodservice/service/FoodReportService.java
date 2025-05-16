package com.hcmus.foodservice.service;

import com.hcmus.foodservice.dto.response.ApiResponse;
import com.hcmus.foodservice.dto.response.FoodReportResponse;

import org.springframework.data.domain.Pageable;

import java.util.List;
import java.util.UUID;

public interface FoodReportService {
    ApiResponse<FoodReportResponse> getFoodReport();    
}
