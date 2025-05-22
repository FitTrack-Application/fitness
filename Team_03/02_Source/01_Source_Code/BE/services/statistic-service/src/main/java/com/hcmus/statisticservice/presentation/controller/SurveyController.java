package com.hcmus.statisticservice.presentation.controller;

import com.hcmus.statisticservice.application.dto.request.SaveSurveyRequest;
import com.hcmus.statisticservice.application.dto.response.ApiResponse;
import com.hcmus.statisticservice.application.dto.response.CheckSurveyResponse;
import com.hcmus.statisticservice.application.service.SurveyService;
import com.hcmus.statisticservice.infrastructure.security.CustomSecurityContextHolder;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RequiredArgsConstructor
@RestController
@Slf4j
@RequestMapping("/api/surveys")
public class SurveyController {

    private final SurveyService surveyService;

    @GetMapping("/me")
    public ResponseEntity<ApiResponse<CheckSurveyResponse>> checkSurvey() {
        UUID userId = CustomSecurityContextHolder.getCurrentUserId();

        log.info("Check survey for user: {}", userId);
        ApiResponse<CheckSurveyResponse> response = surveyService.getCheckSurveyResponse(userId);

        return ResponseEntity.ok(response);
    }

    @PostMapping("/me")
    public ResponseEntity<ApiResponse<?>> saveSurvey(@Valid @RequestBody SaveSurveyRequest saveSurveyRequest) {
        UUID userId = CustomSecurityContextHolder.getCurrentUserId();

        log.info("Save survey details for user: {}", userId);
        ApiResponse<?> response = surveyService.saveSurvey(userId, saveSurveyRequest);

        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }
}