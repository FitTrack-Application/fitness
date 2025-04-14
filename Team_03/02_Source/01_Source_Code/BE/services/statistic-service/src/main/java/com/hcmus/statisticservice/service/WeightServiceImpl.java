package com.hcmus.statisticservice.service;

import com.hcmus.statisticservice.dto.request.AddWeightRequest;
import com.hcmus.statisticservice.dto.request.InitWeightGoalRequest;
import com.hcmus.statisticservice.dto.response.ApiResponse;
import com.hcmus.statisticservice.model.WeightGoal;
import com.hcmus.statisticservice.model.WeightLog;
import com.hcmus.statisticservice.repository.WeightGoalRepository;
import com.hcmus.statisticservice.repository.WeightLogRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class WeightServiceImpl implements WeightService {

    private final WeightLogRepository weightLogRepository;

    private final WeightGoalRepository weightGoalRepository;

    public ApiResponse<Void> addWeight(AddWeightRequest request, UUID userId) {
        WeightLog weightLog = new WeightLog();

        weightLog.setUserId(userId);
        weightLog.setWeight(request.getWeight());
        weightLog.setDate(request.getUpdateDate());
        weightLog.setImageUrl(request.getProgressPhoto());

        weightLogRepository.save(weightLog);

        return ApiResponse.<Void>builder()
                .status(HttpStatus.OK.value())
                .generalMessage("Successfully added weight log")
                .data(null)
                .timestamp(LocalDateTime.now())
                .build();
    }

    public ApiResponse<List<Map<String, Object>>> getWeightProcess(UUID userId) {
        List<WeightLog> weightLogs = weightLogRepository.findByUserId(userId);

        if (weightLogs.isEmpty()) {
            return ApiResponse.<List<Map<String, Object>>>builder()
                    .status(HttpStatus.NOT_FOUND.value())
                    .generalMessage("No weight logs found for this user")
                    .data(null)
                    .timestamp(LocalDateTime.now())
                    .build();
        }

        List<Map<String, Object>> dataList = weightLogs.stream()
                .map(log -> {
                    Map<String, Object> map = new HashMap<>();
                    map.put("weight", log.getWeight());
                    map.put("date", log.getDate());
                    return map;
                })
                .toList();

        return ApiResponse.<List<Map<String, Object>>>builder()
                .status(HttpStatus.OK.value())
                .generalMessage("Successfully retrieved weight logs")
                .data(dataList)
                .timestamp(LocalDateTime.now())
                .build();
    }

    @Override
    public ApiResponse<?> initWeightGoal(InitWeightGoalRequest initWeightGoalRequest, UUID userId) {
        WeightGoal weightGoal = WeightGoal.builder()
                .goalWeight(initWeightGoalRequest.getGoalWeight())
                .weeklyGoal(initWeightGoalRequest.getWeeklyGoal())
                .startingWeight(initWeightGoalRequest.getStartingWeight())
                .startingDate(initWeightGoalRequest.getStartingDate())
                .userId(userId)
                .build();
        weightGoalRepository.save(weightGoal);
        return ApiResponse.builder()
                .status(HttpStatus.CREATED.value())
                .generalMessage("Successfully initialized weight goal!")
                .timestamp(LocalDateTime.now())
                .build();
    }
}
