package com.hcmus.statisticservice.controller;

import com.hcmus.statisticservice.dto.request.WeightLogRequest;
import com.hcmus.statisticservice.dto.response.ApiResponse;
import com.hcmus.statisticservice.dto.response.WeightLogResponse;
import com.hcmus.statisticservice.service.WeightLogService;
import com.hcmus.statisticservice.util.JwtUtil;
import jakarta.validation.Valid;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@AllArgsConstructor
@Slf4j
@RestController
@RequestMapping("/api/weight-logs")
public class WeightLogController {

    private final JwtUtil jwtUtil;
    private final WeightLogService weightLogService;

    @GetMapping("/me")
    public ResponseEntity<ApiResponse<List<WeightLogResponse>>> getWeightProgress(@RequestParam(value = "days", defaultValue = "7") Integer days) {
        UUID userId = jwtUtil.getCurrentUserId();

        log.info("Fetching weight progress for user: {}", userId);
        ApiResponse<List<WeightLogResponse>> response = weightLogService.getWeightProgress(userId, days);

        return ResponseEntity.ok(response);
    }

    @PostMapping("/me")
    public ResponseEntity<ApiResponse<?>> trackWeight(@Valid @RequestBody WeightLogRequest weightLogRequest) {
        UUID userId = jwtUtil.getCurrentUserId();

        log.info("Tracking weight log for user: {}", userId);
        ApiResponse<?> response = weightLogService.getTrackWeightResponse(userId, weightLogRequest);

        return ResponseEntity.ok(response);
    }

}
