package com.hcmus.statisticservice.controller;

import com.hcmus.statisticservice.dto.request.StepLogRequest;
import com.hcmus.statisticservice.dto.response.ApiResponse;
import com.hcmus.statisticservice.dto.response.StepLogResponse;
import com.hcmus.statisticservice.service.StepLogService;
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
@RequestMapping("/api/step-logs")
public class StepLogController {

    private final JwtUtil jwtUtil;
    private final StepLogService stepLogService;

    @GetMapping("/me")
    public ResponseEntity<ApiResponse<List<StepLogResponse>>> getStepProgress(@RequestParam(value = "days", defaultValue = "7") Integer days) {
        UUID userId = jwtUtil.getCurrentUserId();

        log.info("Fetching step progress for user: {}", userId);
        ApiResponse<List<StepLogResponse>> response = stepLogService.getStepProgress(userId, days);

        return ResponseEntity.ok(response);
    }

    @PostMapping("/me")
    public ResponseEntity<ApiResponse<?>> trackStep(@Valid @RequestBody StepLogRequest stepLogRequest) {
        UUID userId = jwtUtil.getCurrentUserId();

        log.info("Tracking step log for user: {}", userId);
        ApiResponse<?> response = stepLogService.getTrackStepResponse(userId, stepLogRequest);

        return ResponseEntity.ok(response);
    }
}
