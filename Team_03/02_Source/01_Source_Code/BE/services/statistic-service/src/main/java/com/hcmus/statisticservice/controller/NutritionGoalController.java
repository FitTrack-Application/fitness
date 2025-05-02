package com.hcmus.statisticservice.controller;

import com.hcmus.statisticservice.dto.response.ApiResponse;
import com.hcmus.statisticservice.dto.response.GetNutritionGoalResponse;
import com.hcmus.statisticservice.service.NutritionGoalService;
import com.hcmus.statisticservice.util.JwtUtil;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.UUID;

@AllArgsConstructor
@RestController
@Slf4j
@RequestMapping("/api/nutrition-goals")
public class NutritionGoalController {

    private final JwtUtil jwtUtil;
    private final NutritionGoalService nutritionGoalService;

    @GetMapping("/me")
    public ResponseEntity<ApiResponse<GetNutritionGoalResponse>> getNutritionGoal() {
        UUID userId = jwtUtil.getCurrentUserId();

        log.info("Get nutrition goal for user: {}", userId);
        ApiResponse<GetNutritionGoalResponse> response = nutritionGoalService.getNutritionGoal(userId);

        return ResponseEntity.ok(response);
    }
}
