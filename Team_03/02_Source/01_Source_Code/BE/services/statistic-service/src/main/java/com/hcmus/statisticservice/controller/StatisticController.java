package com.hcmus.statisticservice.controller;

import com.hcmus.statisticservice.dto.request.AddWeightRequest;
import com.hcmus.statisticservice.service.WeightService;
import com.hcmus.statisticservice.util.JwtUtil;

import lombok.AllArgsConstructor;

import java.util.UUID;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@AllArgsConstructor
@RestController
@RequestMapping("/api/statistics")
public class StatisticController {

    private final WeightService weightService;
    private final JwtUtil jwtUtil;

    @GetMapping("/")
    public ResponseEntity<?> testServer() {
        return ResponseEntity.ok("Statistic Service");
    }


    @PostMapping("/add-weight")
    public ResponseEntity<?> addWeight(@RequestBody AddWeightRequest addWeightRequest, @RequestHeader("Authorization") String authorizationHeader) {
        String userIdStr = jwtUtil.extractUserId(authorizationHeader.replace("Bearer ", ""));
        UUID userId = UUID.fromString(userIdStr);

        return ResponseEntity.ok(weightService.addWeight(addWeightRequest, userId));
    }

    @GetMapping("/weight")
    public ResponseEntity<?> getWeightProcess(@RequestHeader("Authorization") String authorizationHeader) {
        String userIdStr = jwtUtil.extractUserId(authorizationHeader.replace("Bearer ", ""));
        UUID userId = UUID.fromString(userIdStr);

        return ResponseEntity.ok(weightService.getWeightProcess(userId));
    }


}
