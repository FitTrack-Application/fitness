package com.hcmus.statisticservice.application.service;

import com.hcmus.statisticservice.application.dto.response.ApiResponse;
import com.hcmus.statisticservice.application.dto.response.DashboardResponse;

import java.util.UUID;

import org.springframework.stereotype.Service;

@Service
public interface DashboardService {
    ApiResponse<DashboardResponse> getDashboard(UUID userId);
    
} 
