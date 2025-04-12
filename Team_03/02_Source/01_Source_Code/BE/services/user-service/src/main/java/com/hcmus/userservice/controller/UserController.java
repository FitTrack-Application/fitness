package com.hcmus.userservice.controller;

import com.hcmus.userservice.dto.UserDto;
import com.hcmus.userservice.dto.request.UpdateProfileRequest;
import com.hcmus.userservice.dto.response.ApiResponse;
import com.hcmus.userservice.dto.response.GoalResponse;
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
    public ResponseEntity<ApiResponse<UserDto>> getUserProfile(@RequestHeader("Authorization") String authorizationHeader) {

        String userIdStr = jwtUtil.extractUserId(authorizationHeader.replace("Bearer ", ""));
        UUID userId = UUID.fromString(userIdStr);

        log.info("Get user profile for user: {}", userId);
        ApiResponse<UserDto> response = userService.getUserProfileResponse(userId);

        return ResponseEntity.ok(response);
    }

    @PutMapping("/me")
    public ResponseEntity<ApiResponse<?>> updateUserProfile(@Valid @RequestBody UpdateProfileRequest updateProfileRequest, @RequestHeader("Authorization") String authorizationHeader) {

        String userIdStr = jwtUtil.extractUserId(authorizationHeader.replace("Bearer ", ""));
        UUID userId = UUID.fromString(userIdStr);

        log.info("Update user profile for user: {}", userId);
        ApiResponse<?> response = userService.getUpdateProfileResponse(updateProfileRequest, userId);

        return ResponseEntity.ok(response);
    }
}

