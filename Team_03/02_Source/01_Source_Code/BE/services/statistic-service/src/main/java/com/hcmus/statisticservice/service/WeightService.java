package com.hcmus.statisticservice.service;

import com.hcmus.statisticservice.repository.WeightRepository;
import com.hcmus.statisticservice.dto.AddWeightRequest;
import com.hcmus.statisticservice.dto.ApiResponse;


import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;
import java.lang.String;

@Service
public class WeightService {
    ApiResponse<Void> addWeight(AddWeightRequest request, UUID userId);
    ApiResponse<List<Map<String, Object>>> getWeightProcess(UUID userId);

}
