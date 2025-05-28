package com.hcmus.statisticservice.infrastructure.client;

import com.hcmus.statisticservice.application.dto.ExerciseDto;
import com.hcmus.statisticservice.application.dto.request.ExerciseRequest;
import com.hcmus.statisticservice.application.dto.response.ApiResponse;
import com.hcmus.statisticservice.application.dto.response.ExerciseReportResponse;
import com.hcmus.statisticservice.application.dto.response.TotalCaloriesBurnedResponse;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;
@FeignClient(
    name = "exercise-service",
    url = "${EXERCISE_SERVICE_HOST}",
    configuration = FeignConfig.class
)

public interface ExerciseServiceClient {
    @GetMapping("api/exercise-reports")
    ApiResponse<ExerciseReportResponse> getExerciseReport();

    @PostMapping("api/exercises")
    ApiResponse<ExerciseDto> createExercise(@RequestBody ExerciseRequest exerciseRequest);

    @GetMapping("api/exercise-log-entries/total-calories-burned/{userId}")
    ApiResponse<TotalCaloriesBurnedResponse> getTotalCaloriesBurnedByUserId(@PathVariable UUID userId);

}
