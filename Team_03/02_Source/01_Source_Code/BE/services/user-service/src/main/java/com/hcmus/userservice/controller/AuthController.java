package com.hcmus.userservice.controller;

import com.hcmus.userservice.dto.request.LoginRequest;
import com.hcmus.userservice.dto.response.ApiResponse;
import com.hcmus.userservice.dto.response.AuthResponse;
import com.hcmus.userservice.dto.request.RegisterRequest;
import com.hcmus.userservice.dto.response.LoginResponse;
import com.hcmus.userservice.service.AuthService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.bind.annotation.RequestHeader;

import java.util.ArrayList;
import java.util.List;
import java.time.LocalDateTime;
import java.util.Map;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody @Valid RegisterRequest request) {
        try {
            return ResponseEntity.ok(authService.register(request));
        } catch (ResponseStatusException e) {
            List<String> errorDetails = new ArrayList<>();
            errorDetails.add("Email is already exist or invalid information");

            ApiResponse<Object> errorResponse = ApiResponse.builder()
                    .status(HttpStatus.CONFLICT.value())
                    .generalMessage("Registration failed")
                    .errorDetails(errorDetails)
                    .timestamp(LocalDateTime.now())
                    .build();

            return ResponseEntity.status(HttpStatus.CONFLICT).body(errorResponse);
        } catch (IllegalArgumentException e) {
            List<String> errorDetails = new ArrayList<>();
            errorDetails.add(e.getMessage());

            ApiResponse<Object> errorResponse = ApiResponse.builder()
                    .status(HttpStatus.BAD_REQUEST.value())
                    .generalMessage("Registration failed")
                    .errorDetails(errorDetails)
                    .timestamp(LocalDateTime.now())
                    .build();

            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(errorResponse);
        }
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody @Valid LoginRequest request) {
        try {
            return ResponseEntity.ok(authService.login(request));
        } catch (IllegalArgumentException e) {
            List<String> errorDetails = new ArrayList<>();
            errorDetails.add(e.getMessage());

            ApiResponse<Object> errorResponse = ApiResponse.builder()
                    .status(HttpStatus.UNAUTHORIZED.value())
                    .generalMessage("Authentication failed")
                    .errorDetails(errorDetails)
                    .timestamp(LocalDateTime.now())
                    .build();

            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(errorResponse);
        }
    }

    @PostMapping("/verify")
    public ResponseEntity<?> verifyToken(@RequestHeader("Authorization") String token) {
        try {
            // Remove "Bearer " prefix if present
            if (token.startsWith("Bearer ")) {
                token = token.substring(7);
            }

            ApiResponse<Map<String, Object>> response = authService.verifyToken(token);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            List<String> errorDetails = new ArrayList<>();
            errorDetails.add(e.getMessage());

            ApiResponse<Object> errorResponse = ApiResponse.builder()
                    .status(HttpStatus.UNAUTHORIZED.value())
                    .generalMessage("Token verification failed")
                    .errorDetails(errorDetails)
                    .timestamp(LocalDateTime.now())
                    .build();

            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(errorResponse);
        }
    }

    @PostMapping("/refresh")
    public ResponseEntity<?> refreshToken(@RequestHeader("Authorization") String refreshToken) {
        try {
            // Remove "Bearer " prefix if present
            if (refreshToken.startsWith("Bearer ")) {
                refreshToken = refreshToken.substring(7);
            }

            ApiResponse<Map<String, String>> response = authService.refreshToken(refreshToken);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            List<String> errorDetails = new ArrayList<>();
            errorDetails.add(e.getMessage());

            ApiResponse<Object> errorResponse = ApiResponse.builder()
                    .status(HttpStatus.UNAUTHORIZED.value())
                    .generalMessage("Token refresh failed")
                    .errorDetails(errorDetails)
                    .timestamp(LocalDateTime.now())
                    .build();

            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(errorResponse);
        }
    }
}
