package com.hcmus.statisticservice.presentation.controller;

import com.hcmus.statisticservice.application.dto.response.ApiResponse;
import com.hcmus.statisticservice.application.dto.response.DashboardResponse;
import com.hcmus.statisticservice.application.service.DashboardService;
import com.hcmus.statisticservice.infrastructure.security.CustomSecurityContextHolder;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import java.util.UUID;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;


@RequiredArgsConstructor
@RestController
@Slf4j
@RequestMapping("/api/dashboard")
public class DashboardController {
    private final DashboardService dashboardService;

    @GetMapping("/me")
    public ResponseEntity<ApiResponse<DashboardResponse>> getDashboard() {
        UUID userId = CustomSecurityContextHolder.getCurrentUserId();
        ApiResponse<DashboardResponse> response = dashboardService.getDashboard(userId);
        return ResponseEntity.ok(response);
    }

}
