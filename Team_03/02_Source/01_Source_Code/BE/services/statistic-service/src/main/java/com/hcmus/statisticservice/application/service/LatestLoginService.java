package com.hcmus.statisticservice.application.service;

import com.hcmus.statisticservice.application.dto.response.ApiResponse;
import com.hcmus.statisticservice.domain.model.LatestLogin;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.UUID;

@Service
public interface LatestLoginService {
    ApiResponse<?> updateLatestLogin(UUID userId);    
}
