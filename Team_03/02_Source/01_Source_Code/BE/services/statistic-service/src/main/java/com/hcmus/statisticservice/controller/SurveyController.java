package com.hcmus.statisticservice.controller;

import com.hcmus.statisticservice.dto.request.SaveSurveyRequest;
import com.hcmus.statisticservice.dto.response.ApiResponse;
import com.hcmus.statisticservice.dto.response.CheckSurveyResponse;
import com.hcmus.statisticservice.service.SurveyService;
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
@RequestMapping("/api/surveys")
public class SurveyController {

    private final JwtUtil jwtUtil;
    private final SurveyService surveyService;

    @GetMapping("/me")
    public ResponseEntity<ApiResponse<CheckSurveyResponse>> checkSurvey() {
        UUID userId = jwtUtil.getCurrentUserId();

        log.info("Check survey for user: {}", userId);
        ApiResponse<CheckSurveyResponse> response = surveyService.getCheckSurveyResponse(userId);

        return ResponseEntity.ok(response);
    }

    @PutMapping("/me")
    public ResponseEntity<ApiResponse<?>> saveSurvey(@Valid @RequestBody SaveSurveyRequest saveSurveyRequest) {
        UUID userId = jwtUtil.getCurrentUserId();

        log.info("Save survey details for user: {}", userId);
        ApiResponse<?> response = surveyService.saveSurvey(userId, saveSurveyRequest);

        return ResponseEntity.ok(response);
    }
}
