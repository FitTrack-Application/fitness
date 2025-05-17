package com.hcmus.statisticservice.presentation.controller;

import com.hcmus.statisticservice.application.dto.request.UpdateProfileRequest;
import com.hcmus.statisticservice.application.dto.response.ApiResponse;
import com.hcmus.statisticservice.application.dto.response.FitProfileResponse;
import com.hcmus.statisticservice.application.service.FitProfileService;
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
@RequestMapping("/api/fit-profiles")
public class FitProfileController {

    private final FitProfileService fitProfileService;

    @GetMapping("/me")
    public ResponseEntity<ApiResponse<FitProfileResponse>> getFitProfile() {
        UUID userId = CustomSecurityContextHolder.getCurrentUserId();

        log.info("Get fit profile for user: {}", userId);
        ApiResponse<FitProfileResponse> response = fitProfileService.getFindProfileResponse(userId);

        return ResponseEntity.ok(response);
    }

    @PutMapping("/me")
    public ResponseEntity<ApiResponse<?>> updateFitProfile(
            @Valid @RequestBody UpdateProfileRequest updateProfileRequest) {
        UUID userId = CustomSecurityContextHolder.getCurrentUserId();

        log.info("Update fit profile for user: {}", userId);
        ApiResponse<?> response = fitProfileService.getUpdateProfileResponse(userId, updateProfileRequest);

        return ResponseEntity.ok(response);
    }
}