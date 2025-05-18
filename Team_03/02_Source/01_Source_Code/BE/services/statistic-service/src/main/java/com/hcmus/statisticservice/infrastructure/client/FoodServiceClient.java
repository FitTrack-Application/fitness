package com.hcmus.statisticservice.infrastructure.client;

import com.hcmus.statisticservice.application.dto.response.ApiResponse;
import com.hcmus.statisticservice.application.dto.response.FoodReportResponse;
import com.hcmus.statisticservice.infrastructure.client.FeignConfig;
import com.hcmus.statisticservice.application.dto.request.FoodRequest;

import jakarta.validation.Valid;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.Map;


@FeignClient(
    name = "food-service",
    url = "${FOOD_SERVICE_HOST}",
    configuration = FeignConfig.class
)

public interface FoodServiceClient {
    @GetMapping("api/food-reports")
    ApiResponse<FoodReportResponse> getFoodReport();

    @PostMapping("api/foods")
    ApiResponse<?> addFood(@Valid @RequestBody FoodRequest foodRequest);
}
