package com.hcmus.statisticservice.service;

import com.hcmus.statisticservice.repository.WeightRepository;
import com.hcmus.statisticservice.dto.request.AddWeightRequest;
import com.hcmus.statisticservice.dto.response.ApiResponse;


import org.springframework.stereotype.Service;
import java.util.UUID;
import java.util.Map;
import java.lang.Object;

import java.time.LocalDate;
import java.util.List;
import java.lang.String;

@Service
public interface WeightService {
    ApiResponse<Void> addWeight(AddWeightRequest request, UUID userId);
    ApiResponse<List<Map<String, Object>>> getWeightProcess(UUID userId);

}
