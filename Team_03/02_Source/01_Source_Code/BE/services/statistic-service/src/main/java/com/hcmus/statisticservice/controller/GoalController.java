package com.hcmus.statisticservice.controller;

import com.hcmus.statisticservice.dto.request.EditGoalRequest;
import com.hcmus.statisticservice.service.StatisticService;
import com.hcmus.statisticservice.util.JwtUtil;

import lombok.AllArgsConstructor;

import java.util.UUID;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@AllArgsConstructor
@RestController
@RequestMapping("/api/goal")
public class GoalController {

    private final StatisticService statisticService;

    private final JwtUtil jwtUtil;

    @GetMapping
    public ResponseEntity<?> getGoal(@RequestHeader("Authorization") String authorizationHeader) {
        UUID userId = jwtUtil.extractUserId(authorizationHeader.replace("Bearer ", ""));
        return ResponseEntity.ok(statisticService.getGoal(userId, authorizationHeader));
    }

    @PutMapping("/edit")
    public ResponseEntity<?> editGoal(@RequestBody EditGoalRequest editGoalRequest, @RequestHeader("Authorization") String authorizationHeader) {
        UUID userId = jwtUtil.extractUserId(authorizationHeader.replace("Bearer ", ""));
        return ResponseEntity.ok(statisticService.editGoal(editGoalRequest, userId, authorizationHeader));
    }
}
