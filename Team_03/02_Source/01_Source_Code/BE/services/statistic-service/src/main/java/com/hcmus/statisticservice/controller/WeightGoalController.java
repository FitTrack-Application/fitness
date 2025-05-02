package com.hcmus.statisticservice.controller;

import com.hcmus.statisticservice.dto.request.UpdateWeightGoalRequest;
import com.hcmus.statisticservice.dto.response.ApiResponse;
import com.hcmus.statisticservice.dto.response.GetWeightGoalResponse;
import com.hcmus.statisticservice.service.WeightGoalService;
import com.hcmus.statisticservice.util.JwtUtil;
import jakarta.validation.Valid;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@AllArgsConstructor
@RestController
@Slf4j
@RequestMapping("/api/weight-goals")
public class WeightGoalController {

    private final JwtUtil jwtUtil;
    private final WeightGoalService weightGoalService;

    @GetMapping("/me")
    public ResponseEntity<ApiResponse<GetWeightGoalResponse>> getWeightGoal() {
        UUID userId = jwtUtil.getCurrentUserId();

        log.info("Get weight goal for user: {}", userId);
        ApiResponse<GetWeightGoalResponse> response = weightGoalService.getWeightGoal(userId);

        return ResponseEntity.ok(response);
    }

    @PostMapping("/me")
    public ResponseEntity<ApiResponse<?>> updateWeightGoal(@Valid @RequestBody UpdateWeightGoalRequest updateWeightGoalRequest) {
        UUID userId = jwtUtil.getCurrentUserId();

        log.info("Update weight goal for user: {}", userId);
        ApiResponse<?> response = weightGoalService.getUpdateWeightGoalResponse(userId, updateWeightGoalRequest);

        return ResponseEntity.ok(response);
    }
}
