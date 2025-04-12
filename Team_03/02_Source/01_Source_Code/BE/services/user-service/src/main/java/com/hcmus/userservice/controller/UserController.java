package com.hcmus.userservice.controller;

import com.hcmus.userservice.dto.response.UserProfileResponse;
import com.hcmus.userservice.dto.request.UpdateProfileRequest;
import com.hcmus.userservice.dto.response.ApiResponse;
import com.hcmus.userservice.service.UserService;
import com.hcmus.userservice.util.JwtUtil;
import jakarta.validation.Valid;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@AllArgsConstructor
@RestController
@Slf4j
@RequestMapping("/api/users")
public class UserController {

    private final UserService userService;

    private final JwtUtil jwtUtil;

    @GetMapping("/me")
    public ResponseEntity<ApiResponse<UserProfileResponse>> getUserProfile(@RequestHeader("Authorization") String authorizationHeader) {
        UUID userId = UUID.fromString(jwtUtil.extractUserId(authorizationHeader.replace("Bearer ", "")));

        log.info("Get user profile for user: {}", userId);
        ApiResponse<UserProfileResponse> response = userService.getUserProfileResponse(userId);

        return ResponseEntity.ok(response);
    }

    @PutMapping("/me")
    public ResponseEntity<ApiResponse<?>> updateUserProfile(@Valid @RequestBody UpdateProfileRequest updateProfileRequest, @RequestHeader("Authorization") String authorizationHeader) {
        UUID userId = UUID.fromString(jwtUtil.extractUserId(authorizationHeader.replace("Bearer ", "")));

        log.info("Update user profile for user: {}", userId);
        ApiResponse<?> response = userService.getUpdateProfileResponse(updateProfileRequest, userId);

        return ResponseEntity.ok(response);
    }
}

