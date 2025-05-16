package com.hcmus.statisticservice.presentation.controller;

import com.hcmus.statisticservice.application.dto.response.ApiResponse;
import com.hcmus.statisticservice.application.service.AdminReportService;
import com.hcmus.statisticservice.infrastructure.security.CustomSecurityContextHolder;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.MediaType;
import org.springframework.web.multipart.MultipartFile;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.core.JsonProcessingException;
import org.springframework.http.HttpStatus;


import java.util.UUID;

@RequiredArgsConstructor
@RestController
@Slf4j
@RequestMapping("/api/admin")
public class AdminReportController {
    private final AdminReportService adminReportService;

    @GetMapping("/statistics")
    public ResponseEntity<ApiResponse<?>> getAdminReport() {
        ApiResponse<?> response = adminReportService.getAdminReport();

        return ResponseEntity.ok(response);
    }
}
