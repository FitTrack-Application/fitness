package com.hcmus.statisticservice.service;


import com.hcmus.statisticservice.dto.request.StepLogRequest;
import com.hcmus.statisticservice.dto.response.ApiResponse;
import com.hcmus.statisticservice.dto.response.StepLogResponse;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
public interface StepLogService {

    void trackStep(UUID userId, StepLogRequest stepLogRequest);

    ApiResponse<?> getTrackStepResponse(UUID userId, StepLogRequest stepLogRequest);

    ApiResponse<List<StepLogResponse>> getStepProgress(UUID userId, Integer numDays);
}
