package com.hcmus.statisticservice.application.service.impl;

import com.hcmus.statisticservice.application.dto.request.StepLogRequest;
import com.hcmus.statisticservice.application.dto.response.ApiResponse;
import com.hcmus.statisticservice.application.dto.response.StepLogResponse;
import com.hcmus.statisticservice.application.service.StepLogService;
import com.hcmus.statisticservice.domain.model.StepLog;
import com.hcmus.statisticservice.domain.repository.StepLogRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.ZoneId;
import java.util.Date;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class StepLogServiceImpl implements StepLogService {

    private final StepLogRepository stepLogRepository;

    public void trackStep(UUID userId, StepLogRequest stepLogRequest) {
        StepLog stepLog = stepLogRepository.findByUserIdAndDate(userId, stepLogRequest.getDate()).orElse(null);
        if (stepLog == null) {
            stepLog = StepLog.builder()
                    .stepCount(stepLogRequest.getSteps())
                    .date(stepLogRequest.getDate())
                    .userId(userId)
                    .build();
        } else {
            stepLog.setStepCount(stepLogRequest.getSteps());
            stepLog.setDate(stepLogRequest.getDate());
        }
        stepLogRepository.save(stepLog);
    }

    @Override
    public ApiResponse<?> getTrackStepResponse(UUID userId, StepLogRequest stepLogRequest) {
        try {
            trackStep(userId, stepLogRequest);
        } catch (RuntimeException exception) {
            return ApiResponse.builder()
                    .status(HttpStatus.INTERNAL_SERVER_ERROR.value())
                    .generalMessage("Failed to track step log: " + exception.getMessage())
                    .build();
        }
        return ApiResponse.builder()
                .status(HttpStatus.OK.value())
                .generalMessage("Successfully tracked step log!")
                .build();
    }

    public ApiResponse<List<StepLogResponse>> getStepProgress(UUID userId, Integer numDays) {
        List<StepLog> stepLogs = stepLogRepository.findByUserIdAndDateBetweenOrderByDateDesc(
                userId,
                Date.from(LocalDate.now().minusDays(numDays).atStartOfDay(ZoneId.systemDefault()).toInstant()),
                Date.from(LocalDate.now().plusDays(1).atStartOfDay(ZoneId.systemDefault()).toInstant()));
        if (stepLogs.isEmpty()) {
            return ApiResponse.<List<StepLogResponse>>builder()
                    .status(HttpStatus.OK.value())
                    .generalMessage("No step logs found!")
                    .data(List.of())
                    .build();
        }
        List<StepLogResponse> stepLogResponse = stepLogs.stream()
                .map(log -> StepLogResponse.builder()
                        .steps(log.getStepCount())
                        .date(log.getDate())
                        .build())
                .toList();
        return ApiResponse.<List<StepLogResponse>>builder()
                .status(HttpStatus.OK.value())
                .generalMessage("Successfully retrieved step logs!")
                .data(stepLogResponse)
                .build();
    }
}