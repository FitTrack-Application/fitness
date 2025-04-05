package com.hcmus.userservice.service;

import com.hcmus.userservice.dto.request.LoginRequest;
import com.hcmus.userservice.dto.response.ApiResponse;
import com.hcmus.userservice.dto.response.AuthResponse;
import com.hcmus.userservice.dto.request.RegisterRequest;
import com.hcmus.userservice.dto.response.LoginResponse;
import com.hcmus.userservice.model.Role;
import com.hcmus.userservice.model.User;
import com.hcmus.userservice.repository.UserRepository;
import com.hcmus.userservice.utility.JwtUtil;
import lombok.RequiredArgsConstructor;

import java.time.LocalDateTime;

import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.Map;
import java.util.HashMap;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;

    private final PasswordEncoder passwordEncoder;

    private final JwtUtil jwtUtil;

    private final AuthenticationManager authenticationManager;

    public ApiResponse<AuthResponse> register(RegisterRequest request) {
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Email already exists");
        }

        User user = new User();
        user.setName(request.getName());
        user.setEmail(request.getEmail());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setAge(request.getAge());
        user.setGender(request.getGender());
        user.setHeight(request.getHeight());
        user.setWeight(request.getWeight());
        user.setImageUrl(request.getImageUrl());

        // Nếu role không được chỉ định, mặc định là USER
        user.setRole(request.getRole() != null ? request.getRole() : Role.USER);

        userRepository.save(user);
        String token = jwtUtil.generateToken(user);

        AuthResponse authResponse = buildAuthResponse(user, token);

        return ApiResponse.<AuthResponse>builder()
                .status(HttpStatus.OK.value())
                .generalMessage("Register successfully!")
                .data(authResponse)
                .timestamp(LocalDateTime.now())
                .build();
    }

    public ApiResponse<LoginResponse> login(LoginRequest request) {
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        request.getEmail(),
                        request.getPassword()));

        User user = (User) authentication.getPrincipal();
        String accessToken = jwtUtil.generateToken(user);
        String refreshToken = jwtUtil.generateRefreshToken(user);

        LoginResponse loginResponse = LoginResponse.builder()
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .build();
        return ApiResponse.<LoginResponse>builder()
                .status(HttpStatus.OK.value())
                .generalMessage("Login successfully!")
                .data(loginResponse)
                .timestamp(LocalDateTime.now())
                .build();
    }

    private AuthResponse buildAuthResponse(User user, String token) {
        return AuthResponse.builder()
                .token(token)
                .userId(user.getUserId())
                .email(user.getEmail())
                .name(user.getName())
                .role(user.getRole())
                .build();
    }

    public ApiResponse<Map<String, Object>> verifyToken(String token) {
        try {
            // Verify token and extract claims
            Map<String, Object> claims = jwtUtil.validateTokenAndGetClaims(token);

            return ApiResponse.<Map<String, Object>>builder()
                    .status(HttpStatus.OK.value())
                    .generalMessage("Token is valid")
                    .data(claims)
                    .timestamp(LocalDateTime.now())
                    .build();
        } catch (Exception e) {
            throw new IllegalArgumentException("Invalid token: " + e.getMessage());
        }
    }

    public ApiResponse<Map<String, String>> refreshToken(String refreshToken) {
        try {
            // Validate refresh token
            Map<String, Object> claims = jwtUtil.validateRefreshTokenAndGetClaims(refreshToken);

            // Get user from the database
            String email = (String) claims.get("sub");
            User user = userRepository.findByEmail(email)
                    .orElseThrow(() -> new IllegalArgumentException("User not found"));

            // Generate new access token
            String newAccessToken = jwtUtil.generateToken(user);

            Map<String, String> tokens = new HashMap<>();
            tokens.put("accessToken", newAccessToken);

            return ApiResponse.<Map<String, String>>builder()
                    .status(HttpStatus.OK.value())
                    .generalMessage("Token refreshed successfully")
                    .data(tokens)
                    .timestamp(LocalDateTime.now())
                    .build();
        } catch (Exception e) {
            throw new IllegalArgumentException("Invalid refresh token: " + e.getMessage());
        }
    }
}