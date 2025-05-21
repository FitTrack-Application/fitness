package com.hcmus.statisticservice.infrastructure.client;

import com.hcmus.statisticservice.application.dto.response.ApiResponse;
import com.hcmus.statisticservice.application.dto.response.FoodReportResponse;
import com.hcmus.statisticservice.application.dto.response.TotalCaloriesConsumedResponse;
import com.hcmus.statisticservice.application.dto.request.FoodRequest;

import jakarta.validation.Valid;
import java.util.UUID;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;

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

    @GetMapping("api/meal-entries/total-calories-consumed/{userId}")
    ApiResponse<TotalCaloriesConsumedResponse> getTotalCaloriesConsumedByUserId(@PathVariable UUID userId);
}
