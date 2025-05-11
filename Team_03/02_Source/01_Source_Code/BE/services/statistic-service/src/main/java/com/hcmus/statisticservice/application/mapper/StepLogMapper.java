package com.hcmus.statisticservice.application.mapper;

import com.hcmus.statisticservice.domain.model.StepLog;
import com.hcmus.statisticservice.application.dto.request.StepLogRequest;
import com.hcmus.statisticservice.application.dto.response.StepLogResponse;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

import java.util.List;
import java.util.UUID;

@Mapper(componentModel = "spring")
public interface StepLogMapper {

    @Mapping(source = "stepLogRequest.steps", target = "stepCount")
    @Mapping(source = "stepLogRequest.date", target = "date")
    @Mapping(source = "userId", target = "userId")
    StepLog toEntity(StepLogRequest stepLogRequest, UUID userId);

    @Mapping(source = "stepCount", target = "steps")
    @Mapping(source = "date", target = "date")
    StepLogResponse toResponse(StepLog stepLog);

    List<StepLogResponse> toResponseList(List<StepLog> stepLogs);
}