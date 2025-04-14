package com.hcmus.userservice.service;


import com.hcmus.userservice.client.StatisticClient;
import com.hcmus.userservice.dto.request.InitWeightGoalRequest;
import com.hcmus.userservice.dto.request.InitCaloriesGoalRequest;
import com.hcmus.userservice.dto.request.LoginRequest;
import com.hcmus.userservice.dto.request.RegisterRequest;
import com.hcmus.userservice.dto.response.ApiResponse;
import com.hcmus.userservice.dto.response.LoginResponse;
import com.hcmus.userservice.dto.response.RefreshResponse;
import com.hcmus.userservice.dto.response.RegisterResponse;
import com.hcmus.userservice.exception.BadRequestException;
import com.hcmus.userservice.exception.ConflictException;
import com.hcmus.userservice.exception.InvalidTokenException;
import com.hcmus.userservice.exception.UserNotFoundException;
import com.hcmus.userservice.model.User;
import com.hcmus.userservice.model.type.Gender;
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
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Map;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {

    private final UserRepository userRepository;

    private final PasswordEncoder passwordEncoder;

    private final JwtUtil jwtUtil;

    private final AuthenticationManager authenticationManager;

    private final StatisticClient statisticClient;

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

    @Transactional
    public ApiResponse<RegisterResponse> register(RegisterRequest request) {
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new ConflictException("Email already exists!");
        }

        User user = User.builder()
                .name(request.getName())
                .age(request.getAge())
                .email(request.getEmail())
                .height(request.getHeight())
                .gender(Gender.fromString(request.getGender()))
                .weight(request.getWeight())
                .imageUrl(request.getImageUrl())
                .password(passwordEncoder.encode(request.getPassword()))
                .role(Role.USER)
                .enabled(true)
                .build();

        InitWeightGoalRequest initWeightGoalRequest = InitWeightGoalRequest.builder()
                .startingWeight(request.getWeight())
                .startingDate(request.getStartingDate())
                .goalWeight(request.getGoalWeight())
                .weeklyGoal(request.getWeeklyGoal())
                .build();

        User savedUser = userRepository.save(user);

        String accessToken = jwtUtil.generateToken(savedUser);
        String refreshToken = jwtUtil.generateRefreshToken(savedUser);

        ApiResponse<?> statisticResponse = statisticClient.initWeightGoal(
                initWeightGoalRequest,
                "Bearer " + accessToken);

        if (statisticResponse.getStatus() != HttpStatus.CREATED.value()) {
            throw new BadRequestException("Failed to initialize weight goal!");
        }

        InitCaloriesGoalRequest initCaloriesGoalRequest = InitCaloriesGoalRequest.builder()
                .gender(request.getGender())
                .weight(request.getWeight())
                .height(request.getHeight())
                .age(request.getAge())
                .activityLevel(request.getActivityLevel())
                .weeklyGoal(request.getWeeklyGoal())
                .goalType(request.getGoalType())
                .build();

        ApiResponse<?> caloriesResponse = statisticClient.initCaloriesGoal(
                initCaloriesGoalRequest,
                "Bearer " + accessToken);

        if (caloriesResponse.getStatus() != HttpStatus.CREATED.value()) {
            throw new BadRequestException("Failed to initialize calories goal!");
        }

        RegisterResponse registerResponse = RegisterResponse.builder()
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .email(user.getEmail())
                .name(user.getName())
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