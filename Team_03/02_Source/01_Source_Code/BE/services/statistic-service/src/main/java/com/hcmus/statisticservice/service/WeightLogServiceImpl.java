package com.hcmus.statisticservice.service;

import com.hcmus.statisticservice.dto.request.WeightLogRequest;
import com.hcmus.statisticservice.dto.response.ApiResponse;
import com.hcmus.statisticservice.dto.response.WeightLogResponse;
import com.hcmus.statisticservice.exception.StatisticException;
import com.hcmus.statisticservice.model.WeightLog;
import com.hcmus.statisticservice.repository.WeightLogRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class WeightLogServiceImpl implements WeightLogService {

    private final WeightLogRepository weightLogRepository;

    @Override
    public Double getCurrentWeight(UUID userId) {
        WeightLog weightLog = weightLogRepository.findFirstByUserIdOrderByDateDesc(userId).orElseThrow(
                () -> new StatisticException("No weight logs found for user: " + userId)
        );
        return weightLog.getWeight();
    }

    public void trackWeight(UUID userId, WeightLogRequest weightLogRequest) {
        WeightLog weightLog = weightLogRepository.findByUserIdAndDate(userId, weightLogRequest.getUpdateDate()).orElse(null);
        if (weightLog == null) {
            weightLog = WeightLog.builder()
                    .weight(weightLogRequest.getWeight())
                    .date(weightLogRequest.getUpdateDate())
                    .userId(userId)
                    .imageUrl(weightLogRequest.getProgressPhoto())
                    .build();
        } else {
            weightLog.setWeight(weightLogRequest.getWeight());
            weightLog.setDate(weightLogRequest.getUpdateDate());
            weightLog.setImageUrl(weightLogRequest.getProgressPhoto() == null ? weightLog.getImageUrl() : weightLogRequest.getProgressPhoto());
        }
        weightLogRepository.save(weightLog);
    }

    public void trackWeight(UUID userId, WeightLog weightLog) {
        WeightLogRequest weightLogRequest = WeightLogRequest.builder()
                .weight(weightLog.getWeight())
                .updateDate(weightLog.getDate())
                .progressPhoto(weightLog.getImageUrl())
                .build();
        trackWeight(userId, weightLogRequest);
    }

    @Override
    public ApiResponse<?> getTrackWeightResponse(UUID userId, WeightLogRequest weightLogRequest) {
        try {
            trackWeight(userId, weightLogRequest);
        } catch (RuntimeException exception) {
            throw new StatisticException("Failed to track weight log: " + exception.getMessage());
        }
        return ApiResponse.builder()
                .status(HttpStatus.OK.value())
                .generalMessage("Successfully tracked weight log!")
                .timestamp(LocalDateTime.now())
                .build();
    }

    public ApiResponse<List<WeightLogResponse>> getWeightProgress(UUID userId, Integer numDays) {
        List<WeightLog> weightLogs = weightLogRepository.findByUserIdAndDateBetweenOrderByDateDesc(
                userId,
                Date.from(LocalDate.now().minusDays(numDays).atStartOfDay(ZoneId.systemDefault()).toInstant()),
                Date.from(LocalDate.now().plusDays(1).atStartOfDay(ZoneId.systemDefault()).toInstant())
        );
        if (weightLogs.isEmpty()) {
            return ApiResponse.<List<WeightLogResponse>>builder()
                    .status(HttpStatus.OK.value())
                    .generalMessage("No weight logs found!")
                    .data(List.of())
                    .timestamp(LocalDateTime.now())
                    .build();
        }
        List<WeightLogResponse> weightLogResponse = weightLogs.stream()
                .map(log -> WeightLogResponse.builder()
                        .weight(log.getWeight())
                        .date(log.getDate())
                        .build())
                .toList();
        return ApiResponse.<List<WeightLogResponse>>builder()
                .status(HttpStatus.OK.value())
                .generalMessage("Successfully retrieved weight logs!")
                .data(weightLogResponse)
                .timestamp(LocalDateTime.now())
                .build();
    }
}
