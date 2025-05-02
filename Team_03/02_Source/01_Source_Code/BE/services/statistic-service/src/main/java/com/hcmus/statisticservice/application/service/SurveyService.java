package com.hcmus.statisticservice.application.service;

import com.hcmus.statisticservice.application.dto.request.SaveSurveyRequest;
import com.hcmus.statisticservice.application.dto.response.ApiResponse;
import com.hcmus.statisticservice.application.dto.response.CheckSurveyResponse;

import java.util.UUID;

public interface SurveyService {

    ApiResponse<CheckSurveyResponse> getCheckSurveyResponse(UUID userId);

    ApiResponse<?> saveSurvey(UUID userId, SaveSurveyRequest saveSurveyRequest);
}