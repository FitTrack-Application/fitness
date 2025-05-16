package com.hcmus.statisticservice.application.service;

import com.hcmus.statisticservice.application.dto.response.ApiResponse;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.UUID;

@Service
public interface AdminReportService {
    ApiResponse<?> getAdminReport();
}
