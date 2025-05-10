package com.hcmus.gatewayservice.controller;

import com.hcmus.gatewayservice.dto.ApiResponse;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;

@RestController
public class FallbackController {

    @GetMapping("/fallback")
    public ResponseEntity<ApiResponse<?>> fallback() {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(ApiResponse.builder()
                .status(HttpStatus.BAD_REQUEST.value())
                .generalMessage("Service is temporarily unavailable")
                .timestamp(LocalDateTime.now())
                .build());
    }
}