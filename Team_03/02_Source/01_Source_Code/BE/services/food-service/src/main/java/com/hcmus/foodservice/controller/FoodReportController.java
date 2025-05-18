package com.hcmus.foodservice.controller;

import com.hcmus.foodservice.dto.response.ApiResponse;
import com.hcmus.foodservice.dto.response.FoodReportResponse;
import com.hcmus.foodservice.service.FoodReportService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/food-reports")
public class FoodReportController {
    private final FoodReportService foodReportService;
    
    @GetMapping
    public ResponseEntity<ApiResponse<FoodReportResponse>> getFoodReport() {
        ApiResponse<FoodReportResponse> response = foodReportService.getFoodReport();
        return ResponseEntity.ok(response);
    }

}
