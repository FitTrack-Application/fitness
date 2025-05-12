package com.hcmus.gatewayservice.controller;

import com.hcmus.gatewayservice.dto.ApiResponse;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class FallbackController {

    @GetMapping("/fallback")
    public ResponseEntity<ApiResponse<?>> fallback(@RequestParam(value = "service", required = false) String service) {
        String message = service != null
                ? "Service " + service + " is temporarily unavailable!"
                : "Service is temporarily unavailable!";
        return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE).body(ApiResponse.builder()
                .status(HttpStatus.SERVICE_UNAVAILABLE.value())
                .generalMessage(message)
                .build());
    }
}