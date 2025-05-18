package com.hcmus.statisticservice.infrastructure.client;

import com.hcmus.statisticservice.application.dto.response.ApiResponse;
import com.hcmus.statisticservice.application.dto.response.TotalCaloriesConsumedResponse;
import com.hcmus.statisticservice.infrastructure.client.FeignConfig;


import jakarta.validation.Valid;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.Map;
import java.util.UUID;


@FeignClient(
    name = "food-service",
    url = "${FOOD_SERVICE_HOST}",
    configuration = FeignConfig.class
)

public interface FoodServiceClient {
    @GetMapping("/api/meal-entries/total-calories-consumed/{userId}")
    public ResponseEntity<ApiResponse<TotalCaloriesConsumedResponse>> getTotalCaloriesConsumedByUserId(@PathVariable UUID userId);
}
