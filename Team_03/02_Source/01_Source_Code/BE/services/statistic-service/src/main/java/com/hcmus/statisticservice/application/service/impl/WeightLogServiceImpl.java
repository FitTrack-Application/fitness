package com.hcmus.statisticservice.application.service.impl;

import com.hcmus.statisticservice.application.dto.request.WeightLogRequest;
import com.hcmus.statisticservice.application.dto.response.ApiResponse;
import com.hcmus.statisticservice.application.dto.response.WeightLogResponse;
import com.hcmus.statisticservice.application.service.WeightLogService;
import com.hcmus.statisticservice.domain.model.WeightLog;
import com.hcmus.statisticservice.domain.exception.*;
import com.hcmus.statisticservice.domain.repository.WeightLogRepository;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class WeightLogServiceImpl implements WeightLogService {

        private final WeightLogRepository weightLogRepository;

        @Override
        public Double getCurrentWeight(UUID userId) {
                WeightLog weightLog = weightLogRepository.findFirstByUserIdOrderByDateDesc(userId).orElseThrow(
                                () -> new StatisticException("No weight logs found for user: " + userId));
                return weightLog.getWeight();
        }

        public void trackWeight(UUID userId, WeightLogRequest weightLogRequest) {
                LocalDateTime dateTime = weightLogRequest.getUpdateDate().toInstant()
                                .atZone(ZoneId.systemDefault())
                                .toLocalDateTime();

                WeightLog weightLog = weightLogRepository.findByUserIdAndDate(userId, dateTime).orElse(null);
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
                        weightLog.setImageUrl(weightLogRequest.getProgressPhoto() == null ? weightLog.getImageUrl()
                                        : weightLogRequest.getProgressPhoto());
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
                LocalDateTime startDate = LocalDate.now().minusDays(numDays).atStartOfDay(ZoneId.systemDefault())
                                .toLocalDateTime();
                LocalDateTime endDate = LocalDate.now().plusDays(1).atStartOfDay(ZoneId.systemDefault())
                                .toLocalDateTime();

                List<WeightLog> weightLogs = weightLogRepository.findByUserIdAndDateBetweenOrderByDateDesc(
                                userId, startDate, endDate);

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
