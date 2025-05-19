package com.hcmus.statisticservice.presentation.controller;

import com.hcmus.statisticservice.application.dto.request.ExerciseRequest;
import com.hcmus.statisticservice.application.dto.request.FoodRequest;
import com.hcmus.statisticservice.application.dto.response.ApiResponse;
import com.hcmus.statisticservice.application.service.AdminReportService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RequiredArgsConstructor
@RestController
@Slf4j
@RequestMapping("/api/admin")
public class AdminReportController {
    private final AdminReportService adminReportService;

    @GetMapping("/statistics")
    public ResponseEntity<ApiResponse<?>> getAdminReport() {
        ApiResponse<?> response = adminReportService.getAdminReport();

        return ResponseEntity.ok(response);
    }

    @PostMapping("/import/food")
    public ResponseEntity<ApiResponse<?>> importFood(@RequestBody List<FoodRequest> foodRequests) {
        ApiResponse<?> response = adminReportService.importFood(foodRequests);

        return ResponseEntity.ok(response);
    }

    @PostMapping("/import/exercise")
    public ResponseEntity<ApiResponse<?>> importExercise(@RequestBody List<ExerciseRequest> exerciseRequests) {
        ApiResponse<?> response = adminReportService.importExercise(exerciseRequests);

        return ResponseEntity.ok(response);
    }

}
