package com.hcmus.foodservice.service;

import com.hcmus.foodservice.dto.response.ApiResponse;
import com.hcmus.foodservice.dto.response.FoodReportResponse;

public interface FoodReportService {
    ApiResponse<FoodReportResponse> getFoodReport();    
}
