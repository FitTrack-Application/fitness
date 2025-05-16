package com.hcmus.statisticservice.application.service.impl;

import com.hcmus.statisticservice.application.dto.response.ApiResponse;
import com.hcmus.statisticservice.application.service.AdminReportService;
import com.hcmus.statisticservice.domain.exception.StatisticException;
import lombok.RequiredArgsConstructor;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.util.Map;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class AdminReportSeviceImpl implements AdminReportService {
    @Override
    public ApiResponse<?> getAdminReport() {
        return ApiResponse.builder()
                .status(HttpStatus.OK.value())
                .generalMessage("Get profile successfully!")
                .build();
    }
    
}
