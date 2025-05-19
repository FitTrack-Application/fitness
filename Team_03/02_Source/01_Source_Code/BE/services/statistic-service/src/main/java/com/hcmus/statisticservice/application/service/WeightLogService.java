package com.hcmus.statisticservice.application.service;

import com.hcmus.statisticservice.application.dto.request.WeightLogRequest;
import com.hcmus.statisticservice.application.dto.response.ApiResponse;
import com.hcmus.statisticservice.application.dto.response.WeightLogResponse;
import com.hcmus.statisticservice.domain.model.WeightLog;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
public interface WeightLogService {

    void trackWeight(UUID userId, WeightLogRequest weightLogRequest);

    void trackWeight(UUID userId, WeightLog weightLog);

    Double getCurrentWeight(UUID userId);

    ApiResponse<?> getTrackWeightResponse(UUID userId, WeightLogRequest weightLogRequest);

    ApiResponse<List<WeightLogResponse>> getWeightProgress(UUID userId, Integer numDays);
}
