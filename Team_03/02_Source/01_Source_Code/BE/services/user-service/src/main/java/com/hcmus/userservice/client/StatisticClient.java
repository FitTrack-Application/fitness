package com.hcmus.userservice.client;

import com.hcmus.userservice.dto.request.InitWeightGoalRequest;
import com.hcmus.userservice.dto.response.ApiResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;

@FeignClient(name = "statisticClient", url = "${host.statistic-service}")
public interface StatisticClient {

    @PostMapping("/api/statistics/init-weight-goal")
    ApiResponse<?> initWeightGoal(
            @RequestBody InitWeightGoalRequest initWeightGoalRequest,
            @RequestHeader("Authorization") String authorizationHeader);
}
