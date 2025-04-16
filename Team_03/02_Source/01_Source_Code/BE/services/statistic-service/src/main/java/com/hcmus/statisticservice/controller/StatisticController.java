package com.hcmus.statisticservice.controller;

import com.hcmus.statisticservice.dto.request.AddWeightRequest;
import com.hcmus.statisticservice.dto.request.InitWeightGoalRequest;
import com.hcmus.statisticservice.dto.request.InitCaloriesGoalRequest;
import com.hcmus.statisticservice.service.StatisticService;
import com.hcmus.statisticservice.util.JwtUtil;

import lombok.AllArgsConstructor;

import java.util.UUID;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@AllArgsConstructor
@RestController
@RequestMapping("/api/statistics")
public class StatisticController {

    private final StatisticService statisticService;

    private final JwtUtil jwtUtil;

    @PostMapping("/add-weight")
    public ResponseEntity<?> addWeight(@RequestBody AddWeightRequest addWeightRequest, @RequestHeader("Authorization") String authorizationHeader) {
        UUID userId = jwtUtil.extractUserId(authorizationHeader.replace("Bearer ", ""));
        return ResponseEntity.ok(statisticService.addWeight(addWeightRequest, userId));
    }

    @GetMapping("/weight")
    public ResponseEntity<?> getWeightProcess(@RequestHeader("Authorization") String authorizationHeader, @RequestParam(value = "days", defaultValue = "7") Integer days) {
        UUID userId = jwtUtil.extractUserId(authorizationHeader.replace("Bearer ", ""));
        return ResponseEntity.ok(statisticService.getWeightProcess(userId, days));
    }

    @PostMapping("/init-weight-goal")
    public ResponseEntity<?> initWeightGoal(@RequestBody InitWeightGoalRequest initWeightGoalRequest, @RequestHeader("Authorization") String authorizationHeader) {
        UUID userId = jwtUtil.extractUserId(authorizationHeader.replace("Bearer ", ""));
        return ResponseEntity.ok(statisticService.initWeightGoal(initWeightGoalRequest, userId));
    }

    @PostMapping("/init-calories-goal")
    public ResponseEntity<?> initCaloriesGoal(@RequestBody InitCaloriesGoalRequest initCaloriesGoalRequest, @RequestHeader("Authorization") String authorizationHeader) {
        UUID userId = jwtUtil.extractUserId(authorizationHeader.replace("Bearer ", ""));
        return ResponseEntity.ok(statisticService.initCaloriesGoal(initCaloriesGoalRequest, userId));
    }
}
