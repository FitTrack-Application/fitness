package com.hcmus.statisticservice.presentation.controller;

import com.hcmus.statisticservice.application.dto.response.ApiResponse;
import com.hcmus.statisticservice.application.dto.response.GetNutritionGoalResponse;
import com.hcmus.statisticservice.application.service.NutritionGoalService;
import com.hcmus.statisticservice.infrastructure.security.CustomSecurityContextHolder;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.UUID;

@RequiredArgsConstructor
@RestController
@Slf4j
@RequestMapping("/api/nutrition-goals")
public class NutritionGoalController {
    private final NutritionGoalService nutritionGoalService;

    @GetMapping("/me")
    public ResponseEntity<ApiResponse<GetNutritionGoalResponse>> getNutritionGoal() {
        UUID userId = CustomSecurityContextHolder.getCurrentUserId();

        log.info("Get nutrition goal for user: {}", userId);
        ApiResponse<GetNutritionGoalResponse> response = nutritionGoalService.getNutritionGoal(userId);

        return ResponseEntity.ok(response);
    }
}