package com.hcmus.statisticservice.service;

import com.hcmus.statisticservice.dto.request.InitWeightGoalRequest;
import com.hcmus.statisticservice.dto.request.AddWeightRequest;
import com.hcmus.statisticservice.dto.response.ApiResponse;


import org.springframework.stereotype.Service;
import java.util.UUID;
import java.util.Map;
import java.lang.Object;

import java.util.List;
import java.lang.String;

@Service
public interface WeightService {

    ApiResponse<Void> addWeight(AddWeightRequest request, UUID userId);

    ApiResponse<List<Map<String, Object>>> getWeightProcess(UUID userId);

    ApiResponse<?> initWeightGoal(InitWeightGoalRequest initWeightGoalRequest, UUID userId);
}
