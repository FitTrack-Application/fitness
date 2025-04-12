package com.hcmus.userservice.service;

import com.hcmus.userservice.dto.request.LoginRequest;
import com.hcmus.userservice.dto.request.RegisterRequest;
import com.hcmus.userservice.dto.response.ApiResponse;
import com.hcmus.userservice.dto.response.RegisterResponse;
import com.hcmus.userservice.dto.response.LoginResponse;
import com.hcmus.userservice.dto.response.RefreshResponse;
import org.springframework.stereotype.Service;

import java.util.Map;

@Service
public interface AuthService {

    ApiResponse<Boolean> checkEmail(String email);

    ApiResponse<RegisterResponse> register(RegisterRequest request);

    ApiResponse<LoginResponse> login(LoginRequest request);

    ApiResponse<Map<String, Object>> verifyToken(String token);

    ApiResponse<RefreshResponse> getRefreshResponse(String refreshToken);
}