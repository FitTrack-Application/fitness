package com.hcmus.userservice.service;

import com.hcmus.userservice.dto.request.LoginRequest;
import com.hcmus.userservice.dto.response.ApiResponse;
import com.hcmus.userservice.dto.response.AuthResponse;
import com.hcmus.userservice.dto.request.RegisterRequest;
import com.hcmus.userservice.dto.response.LoginResponse;
import com.hcmus.userservice.exception.UserNotFoundException;
import com.hcmus.userservice.model.Goal;
import com.hcmus.userservice.model.Role;
import com.hcmus.userservice.model.User;
import com.hcmus.userservice.repository.UserRepository;
import com.hcmus.userservice.repository.GoalRepository;
import com.hcmus.userservice.util.JwtUtil;
import lombok.RequiredArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;

import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.Map;
import java.util.UUID;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.client.RestTemplate;
import com.hcmus.userservice.dto.request.AddWeightRequest;

@Service
public interface AuthService {

    ApiResponse<Boolean> checkEmail(String email);

    ApiResponse<AuthResponse> register(RegisterRequest request);

    ApiResponse<LoginResponse> login(LoginRequest request);

    ApiResponse<Map<String, Object>> verifyToken(String token);

    ApiResponse<Map<String, String>> refreshToken(String refreshToken);

    ApiResponse<?> getUserIdAndGoalId(UUID userId);
}