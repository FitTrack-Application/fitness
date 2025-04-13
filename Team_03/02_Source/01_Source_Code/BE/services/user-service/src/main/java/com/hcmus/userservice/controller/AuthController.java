package com.hcmus.userservice.controller;

import com.hcmus.userservice.dto.request.CheckEmailRequest;
import com.hcmus.userservice.dto.request.LoginRequest;
import com.hcmus.userservice.dto.request.RefreshRequest;
import com.hcmus.userservice.dto.request.RegisterRequest;
import com.hcmus.userservice.dto.response.ApiResponse;
import com.hcmus.userservice.dto.response.LoginResponse;
import com.hcmus.userservice.dto.response.RefreshResponse;
import com.hcmus.userservice.dto.response.RegisterResponse;
import com.hcmus.userservice.exception.InvalidTokenException;
import com.hcmus.userservice.service.AuthService;
import com.hcmus.userservice.util.JwtUtil;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
@Slf4j
public class AuthController {

    private final AuthService authService;

    @PostMapping("/check-email")
    public ResponseEntity<ApiResponse<Boolean>> checkEmail(@RequestBody @Valid CheckEmailRequest request) {
        log.info("Check email: {}", request.getEmail());
        ApiResponse<Boolean> response = authService.checkEmail(request.getEmail());

        return ResponseEntity.ok(response);
    }

    @PostMapping("/register")
    public ResponseEntity<ApiResponse<RegisterResponse>> register(@RequestBody @Valid RegisterRequest request) {
        log.info("Register new user");
        ApiResponse<RegisterResponse> response = authService.register(request);

        return ResponseEntity.ok(response);
    }

    @PostMapping("/login")
    public ResponseEntity<ApiResponse<LoginResponse>> login(@RequestBody @Valid LoginRequest request) {
        log.info("Login user");
        ApiResponse<LoginResponse> response = authService.login(request);

        return ResponseEntity.ok(response);
    }

    @PostMapping("/verify")
    public ResponseEntity<ApiResponse<Map<String, Object>>> verifyToken(@RequestHeader("Authorization") String authorization) {
        if (authorization.startsWith("Bearer ")) {
            authorization = authorization.substring(7);
        } else {
            throw new InvalidTokenException("Invalid token!");
        }
        log.info("Verify token!");
        ApiResponse<Map<String, Object>> response = authService.verifyToken(authorization);

        return ResponseEntity.ok(response);
    }

    @PostMapping("/refresh")
    public ResponseEntity<ApiResponse<RefreshResponse>> refreshToken(@RequestBody @Valid RefreshRequest refreshRequest) {
        log.info("Refresh token!");
        ApiResponse<RefreshResponse> response = authService.getRefreshResponse(refreshRequest.getRefreshToken());

        return ResponseEntity.ok(response);
    }
}
