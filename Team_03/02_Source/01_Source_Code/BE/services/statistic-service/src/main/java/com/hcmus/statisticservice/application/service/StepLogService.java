package com.hcmus.statisticservice.application.service;

import com.hcmus.statisticservice.application.dto.request.StepLogRequest;
import com.hcmus.statisticservice.application.dto.response.ApiResponse;
import com.hcmus.statisticservice.application.dto.response.StepLogResponse;

import java.util.List;
import java.util.UUID;

public interface StepLogService {
    void trackStep(UUID userId, StepLogRequest stepLogRequest);

    ApiResponse<?> getTrackStepResponse(UUID userId, StepLogRequest stepLogRequest);

    ApiResponse<List<StepLogResponse>> getStepProgress(UUID userId, Integer numDays);
}