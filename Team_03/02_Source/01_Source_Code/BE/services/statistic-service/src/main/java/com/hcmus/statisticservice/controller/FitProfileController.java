package com.hcmus.statisticservice.controller;

import com.hcmus.statisticservice.dto.request.UpdateProfileRequest;
import com.hcmus.statisticservice.dto.response.ApiResponse;
import com.hcmus.statisticservice.dto.response.FitProfileResponse;
import com.hcmus.statisticservice.service.FitProfileService;
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
@RequestMapping("/api/fit-profiles")
public class FitProfileController {

    private final JwtUtil jwtUtil;
    private final FitProfileService fitProfileService;

    @GetMapping("/me")
    public ResponseEntity<ApiResponse<FitProfileResponse>> getFitProfile() {
        UUID userId = jwtUtil.getCurrentUserId();

        log.info("Get fit profile for user: {}", userId);
        ApiResponse<FitProfileResponse> response = fitProfileService.getFindProfileResponse(userId);

        return ResponseEntity.ok(response);
    }

    @PostMapping("/me")
    public ResponseEntity<ApiResponse<?>> updateFitProfile(@Valid @RequestBody UpdateProfileRequest updateProfileRequest) {
        UUID userId = jwtUtil.getCurrentUserId();

        log.info("Update fit profile for user: {}", userId);
        ApiResponse<?> response = fitProfileService.getUpdateProfileResponse(userId, updateProfileRequest);

        return ResponseEntity.ok(response);
    }
}
