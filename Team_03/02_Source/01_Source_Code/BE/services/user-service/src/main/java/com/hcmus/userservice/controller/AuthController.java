package com.hcmus.userservice.controller;

import com.hcmus.userservice.dto.request.LoginRequest;
import com.hcmus.userservice.dto.request.CheckEmailRequest;
import com.hcmus.userservice.dto.response.ApiResponse;
import com.hcmus.userservice.dto.request.RegisterRequest;
import com.hcmus.userservice.service.AuthService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.bind.annotation.RequestHeader;
import com.hcmus.userservice.util.JwtUtil;

import java.util.ArrayList;
import java.util.List;
import java.time.LocalDateTime;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;
    private final JwtUtil jwtUtil;

    @PostMapping("/checkemail")
    public ResponseEntity<?> checkEmail(@RequestBody @Valid CheckEmailRequest request) {
        try {
            return ResponseEntity.ok(authService.checkEmail(request.getEmail()));
        } catch (ResponseStatusException e) {
            
            ApiResponse<Object> errorResponse = ApiResponse.builder()
                    .status(HttpStatus.CONFLICT.value())
                    .generalMessage("Email is already exist")
                    .timestamp(LocalDateTime.now())
                    .build();

            return ResponseEntity.status(HttpStatus.CONFLICT).body(errorResponse);
        }
    }

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

    @GetMapping("/getUserIdAndGoalId")
    public ResponseEntity<?> getUserIdAndGoalId(@RequestHeader("Authorization") String token) {
        String userIdStr = jwtUtil.extractUserId(token.replace("Bearer ", ""));
        UUID userId = UUID.fromString(userIdStr);
        return ResponseEntity.ok(authService.getUserIdAndGoalId(userId));
    }
}
