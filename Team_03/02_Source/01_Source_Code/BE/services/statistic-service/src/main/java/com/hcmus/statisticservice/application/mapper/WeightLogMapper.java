package com.hcmus.statisticservice.application.mapper;

import com.hcmus.statisticservice.application.dto.request.WeightLogRequest;
import com.hcmus.statisticservice.application.dto.response.WeightLogResponse;
import com.hcmus.statisticservice.domain.model.WeightLog;
import org.springframework.stereotype.Component;

import java.time.ZoneId;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Component
public class WeightLogMapper {

    public WeightLog toEntity(WeightLogRequest request, UUID userId) {
        return WeightLog.builder()
                .userId(userId)
                .weight(request.getWeight())
                .date(request.getUpdateDate().toInstant().atZone(ZoneId.systemDefault()).toLocalDate())
                .imageUrl(request.getProgressPhoto())
                .build();
    }

    public WeightLogResponse toResponse(WeightLog weightLog) {
        return WeightLogResponse.builder()
                .weight(weightLog.getWeight())
                .date(weightLog.getDate())
                .build();
    }

    public List<WeightLogResponse> toResponseList(List<WeightLog> weightLogs) {
        return weightLogs.stream()
                .map(this::toResponse)
                .collect(Collectors.toList());
    }
}