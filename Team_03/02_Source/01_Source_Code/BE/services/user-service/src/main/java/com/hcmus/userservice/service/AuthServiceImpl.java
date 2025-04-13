package com.hcmus.userservice.service;

import com.hcmus.userservice.dto.request.LoginRequest;
import com.hcmus.userservice.dto.request.RegisterRequest;
import com.hcmus.userservice.dto.response.ApiResponse;
import com.hcmus.userservice.dto.response.RegisterResponse;
import com.hcmus.userservice.dto.response.LoginResponse;
import com.hcmus.userservice.dto.response.RefreshResponse;
import com.hcmus.userservice.exception.ConflictException;
import com.hcmus.userservice.exception.InvalidTokenException;
import com.hcmus.userservice.exception.UserNotFoundException;
import com.hcmus.userservice.model.type.Role;
import com.hcmus.userservice.repository.UserRepository;
import com.hcmus.userservice.util.JwtUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import com.hcmus.userservice.model.User;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {

    private final UserRepository userRepository;

    private final PasswordEncoder passwordEncoder;

    private final JwtUtil jwtUtil;

    private final AuthenticationManager authenticationManager;

    public ApiResponse<Boolean> checkEmail(String email) {
        if (userRepository.existsByEmail(email)) {
            throw new ConflictException("Email already exists!");
        }

        return ApiResponse.<Boolean>builder()
                .status(HttpStatus.OK.value())
                .generalMessage("Email is available to create!")
                .data(true)
                .timestamp(LocalDateTime.now())
                .build();
    }

    public ApiResponse<RegisterResponse> register(RegisterRequest request) {
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new ConflictException("Email already exists!");
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
        user.setRole(request.getRole() != null ? request.getRole() : Role.USER);
        user.setEnabled(true);

        User savedUser = userRepository.save(user);

        

        String accessToken = jwtUtil.generateToken(savedUser);
        String refreshToken = jwtUtil.generateRefreshToken(savedUser);
        RegisterResponse registerResponse = RegisterResponse.builder()
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .userId(savedUser.getUserId())
                .email(savedUser.getEmail())
                .name(savedUser.getName())
                .role(savedUser.getRole())
                .message("Successfully get user information and create goal")
                .build();

        

        return ApiResponse.<RegisterResponse>builder()
                .status(HttpStatus.CREATED.value())
                .generalMessage("Register successfully!")
                .data(registerResponse)
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

    public ApiResponse<Map<String, Object>> verifyToken(String token) {
        try {
            Map<String, Object> claims = jwtUtil.validateTokenAndGetClaims(token);
            return ApiResponse.<Map<String, Object>>builder()
                    .status(HttpStatus.OK.value())
                    .generalMessage("Token is valid!")
                    .data(claims)
                    .timestamp(LocalDateTime.now())
                    .build();
        } catch (Exception e) {
            throw new InvalidTokenException("Invalid token: " + e.getMessage() + "!");
        }
    }

    public ApiResponse<RefreshResponse> getRefreshResponse(String refreshToken) {
        try {
            Map<String, Object> claims = jwtUtil.validateRefreshTokenAndGetClaims(refreshToken);

            String email = (String) claims.get("sub");
            User user = userRepository.findByEmail(email)
                    .orElseThrow(() -> new UserNotFoundException("User not found!"));
            String newAccessToken = jwtUtil.generateToken(user);
            RefreshResponse response = new RefreshResponse(newAccessToken);

            return ApiResponse.<RefreshResponse>builder()
                    .status(HttpStatus.OK.value())
                    .generalMessage("Token refreshed successfully!")
                    .data(response)
                    .timestamp(LocalDateTime.now())
                    .build();
        } catch (Exception e) {
            throw new InvalidTokenException("Invalid refresh token: " + e.getMessage() + "!");
        }
    }
}