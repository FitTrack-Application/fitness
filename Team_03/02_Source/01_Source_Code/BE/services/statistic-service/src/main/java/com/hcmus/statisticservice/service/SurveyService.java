package com.hcmus.statisticservice.service;

import com.hcmus.statisticservice.dto.request.SaveSurveyRequest;
import com.hcmus.statisticservice.dto.response.ApiResponse;
import com.hcmus.statisticservice.dto.response.CheckSurveyResponse;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
public interface SurveyService {

    ApiResponse<CheckSurveyResponse> getCheckSurveyResponse(UUID userId);

    ApiResponse<?> saveSurvey(UUID userId, SaveSurveyRequest saveSurveyRequest);
}
