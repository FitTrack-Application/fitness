package com.hcmus.statisticservice.application.service;

import com.hcmus.statisticservice.application.dto.response.ApiResponse;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
public interface LatestLoginService {
    ApiResponse<?> updateLatestLogin(UUID userId);    
}
