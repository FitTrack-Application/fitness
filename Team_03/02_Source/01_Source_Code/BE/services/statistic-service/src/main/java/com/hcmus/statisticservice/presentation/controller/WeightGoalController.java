package com.hcmus.statisticservice.presentation.controller;

import com.hcmus.statisticservice.application.dto.request.UpdateWeightGoalRequest;
import com.hcmus.statisticservice.application.dto.response.ApiResponse;
import com.hcmus.statisticservice.application.dto.response.GetWeightGoalResponse;
import com.hcmus.statisticservice.application.service.WeightGoalService;
import com.hcmus.statisticservice.infrastructure.security.CustomSecurityContextHolder;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RequiredArgsConstructor
@RestController
@Slf4j
@RequestMapping("/api/weight-goals")
public class WeightGoalController {

    private final WeightGoalService weightGoalService;

    @GetMapping("/me")
    public ResponseEntity<ApiResponse<GetWeightGoalResponse>> getWeightGoal() {
        UUID userId = CustomSecurityContextHolder.getCurrentUserId();

        log.info("Get weight goal for user: {}", userId);
        ApiResponse<GetWeightGoalResponse> response = weightGoalService.getWeightGoal(userId);

        return ResponseEntity.ok(response);
    }

    @PutMapping("/me")
    public ResponseEntity<ApiResponse<?>> updateWeightGoal(
            @Valid @RequestBody UpdateWeightGoalRequest updateWeightGoalRequest) {
        UUID userId = CustomSecurityContextHolder.getCurrentUserId();

        log.info("Update weight goal for user: {}", userId);
        ApiResponse<?> response = weightGoalService.getUpdateWeightGoalResponse(userId, updateWeightGoalRequest);

        return ResponseEntity.ok(response);
    }
}