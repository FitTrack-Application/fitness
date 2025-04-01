package com.hcmus.userservice.controller;

import lombok.AllArgsConstructor;
import com.hcmus.userservice.service.UpdateInforUserService;
import com.hcmus.userservice.dto.UserUpdateRequest;
import java.util.UUID;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.hcmus.userservice.utility.JwtUtil;

@AllArgsConstructor
@RestController
@RequestMapping("/api/users")
public class UserController {
    private final UpdateInforUserService updateInforUserService;
    private final JwtUtil jwtUtil;

    @GetMapping
    public ResponseEntity<?> testServer() {
        return ResponseEntity.ok("User service"); // demo
    }

    @PutMapping("/me")
    public ResponseEntity<?> updateUserProfile(@RequestBody UserUpdateRequest userUpdateRequest,
            @RequestHeader("Authorization") String token) {
        String userIdStr = jwtUtil.extractUserId(token.replace("Bearer ", ""));
        UUID userId = UUID.fromString(userIdStr);

        updateInforUserService.updateUserProfile(userUpdateRequest, userId);

        return ResponseEntity.ok(Map.of("status", "success", "data",
                Map.of("message", "Hồ sơ người dùng đã được cập nhật.")));

    }
}
