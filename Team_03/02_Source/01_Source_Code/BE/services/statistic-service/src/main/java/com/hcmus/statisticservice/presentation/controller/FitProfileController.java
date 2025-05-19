package com.hcmus.statisticservice.presentation.controller;

import com.hcmus.statisticservice.application.dto.request.UpdateProfileRequest;
import com.hcmus.statisticservice.application.dto.response.ApiResponse;
import com.hcmus.statisticservice.application.dto.response.FitProfileResponse;
import com.hcmus.statisticservice.application.service.FitProfileService;
import com.hcmus.statisticservice.infrastructure.security.CustomSecurityContextHolder;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.MediaType;
import org.springframework.web.multipart.MultipartFile;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.core.JsonProcessingException;
import org.springframework.http.HttpStatus;


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

    @PostMapping(value = "/me", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<ApiResponse<?>> updateFitProfile(
            @RequestPart("data") String data,
            @RequestPart(value = "image", required = false) MultipartFile imageFile) {

        UpdateProfileRequest updateProfileRequest;

        try {
            ObjectMapper objectMapper = new ObjectMapper();
            updateProfileRequest = objectMapper.readValue(data, UpdateProfileRequest.class);
        } catch (JsonProcessingException e) {
            log.error("Failed to parse update profile JSON", e);
            ApiResponse<?> response = ApiResponse.<FitProfileResponse>builder()
                .status(HttpStatus.BAD_REQUEST.value())
                .generalMessage("Invalid JSON format for update profile")
                .build();
            return ResponseEntity.ok(response);
        }

        UUID userId = CustomSecurityContextHolder.getCurrentUserId();
        log.info("Update fit profile for user: {}", userId);

        ApiResponse<?> response = fitProfileService.getUpdateProfileResponse(userId, updateProfileRequest, imageFile);

        return ResponseEntity.ok(response);
    }

}