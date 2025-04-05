package com.hcmus.userservice.controller;

import lombok.AllArgsConstructor;

import com.hcmus.userservice.dto.request.UserUpdateRequest;
import com.hcmus.userservice.dto.response.ApiResponse;
import com.hcmus.userservice.exception.UserNotFoundException;
import com.hcmus.userservice.service.UpdateInforUserService;

import java.util.UUID;
import java.time.LocalDateTime;
import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.http.HttpStatus;

import com.hcmus.userservice.utility.JwtUtil;

@AllArgsConstructor
@RestController
@RequestMapping("/api/users")
public class UserController {
    private final UpdateInforUserService updateInforUserService;
    private final JwtUtil jwtUtil;

    @GetMapping
    public ResponseEntity<?> testServer() {
        return ResponseEntity.ok("User service");
    }

    @PutMapping("/me")
    public ResponseEntity<?> updateUserProfile(@RequestBody UserUpdateRequest userUpdateRequest,
            @RequestHeader("Authorization") String token) {
        try{
            String userIdStr = jwtUtil.extractUserId(token.replace("Bearer ", ""));
            UUID userId = UUID.fromString(userIdStr);
            ApiResponse<?> response = updateInforUserService.updateUserProfile(userUpdateRequest, userId);
            return ResponseEntity.ok(response);
                
        } catch (UserNotFoundException e) {
            ApiResponse<?> errorResponse = ApiResponse.builder()
                    .status(HttpStatus.NOT_FOUND.value())
                    .generalMessage("Không tìm thấy người dùng")
                    .errorDetails(List.of(e.getMessage()))
                    .timestamp(LocalDateTime.now())
                    .build();
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(errorResponse);
        }

    }
}
