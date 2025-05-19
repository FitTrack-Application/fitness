package com.hcmus.statisticservice.infrastructure.client;


import com.hcmus.statisticservice.application.dto.response.ApiResponse;
import com.hcmus.statisticservice.application.dto.response.TotalCaloriesBurnedResponse;
import com.hcmus.statisticservice.infrastructure.client.FeignConfig;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.Map;
import java.util.UUID;

@FeignClient(
    name = "exercise-service",
    url = "${EXERCISE_SERVICE_HOST}",
    configuration = FeignConfig.class
)

public interface ExerciseServiceClient {
    @GetMapping("api/exercise-log-entries/total-calories-burned/{userId}")
    ApiResponse<TotalCaloriesBurnedResponse> getTotalCaloriesBurnedByUserId(@PathVariable UUID userId);
}
