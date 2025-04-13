package com.hcmus.statisticservice.service;

import com.hcmus.statisticservice.dto.request.AddWeightRequest;
import com.hcmus.statisticservice.dto.response.ApiResponse;
import com.hcmus.statisticservice.model.WeightLog;
import com.hcmus.statisticservice.repository.WeightRepository;
import lombok.RequiredArgsConstructor;
import main.java.com.hcmus.statisticservice.dto.response.WeightResponse;
import org.springframework.http.HttpStatus;

import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class WeightServiceImpl {
    private final WeightRepository weightRepository;

    public ApiResponse<Void> addWeight(AddWeightRequest request, UUID userId) {
        WeightLog weightLog = new WeightLog();

        weightLog.setUserId(userId);        
        weightLog.setWeight(request.getWeight());
        weightLog.setDate(request.getUpdateDate());
        weightLog.setImageUrl(request.getProgressPhoto());

        weightRepository.save(weightLog);

        return ApiResponse.<Void>builder()
                .status(HttpStatus.OK.value())
                .generalMessage("Successfully added weight log")
                .data(null)
                .timestamp(LocalDateTime.now())
                .build();        
    }

    public ApiResponse<List<Map<String, Object>>> getWeightProcess(UUID userId) {
        List<WeightLog> weightLogs = weightRepository.findByUserId(userId);

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


    
}
