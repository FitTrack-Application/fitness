package com.hcmus.statisticservice.service;


import com.hcmus.statisticservice.dto.request.UpdateWeightGoalRequest;
import com.hcmus.statisticservice.dto.response.ApiResponse;
import com.hcmus.statisticservice.dto.response.GetWeightGoalResponse;
import com.hcmus.statisticservice.model.WeightGoal;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
public interface WeightGoalService {

    WeightGoal findWeightGoal(UUID userId);

    WeightGoal updateWeightGoal(UUID userId, WeightGoal updateWeightGoal);

    WeightGoal addWeightGoal(UUID userId, WeightGoal addWeightGoal);

    ApiResponse<GetWeightGoalResponse> getWeightGoal(UUID userId);

    ApiResponse<?> getUpdateWeightGoalResponse(UUID userId, UpdateWeightGoalRequest updateWeightGoalRequest);
}
