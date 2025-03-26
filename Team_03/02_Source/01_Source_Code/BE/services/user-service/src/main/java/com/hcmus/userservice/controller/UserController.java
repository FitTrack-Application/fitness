package com.hcmus.userservice.controller;

import lombok.AllArgsConstructor;
import main.java.com.hcmus.userservice.service.UpdateInforUserService;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.hcmus.userservice.utility.JwtUtil;

@AllArgsConstructor
@RestController
@RequestMapping("/api/user")
public class UserController {
    private final UpdateInforUserService updateInforUserService;
    private final JwtUtil jwtUtil;

    @GetMapping
    public ResponseEntity<?> testServer() {
        return ResponseEntity.ok("User service"); // demo
    }

    @PutMapping("/update")
    public ResponseEntity<?> updateUserProfile(@RequestBody UserUpdateRequest userUpdateRequest, @RequestHeader("Authorization") String token) {
        UUID userId = jwtUtil.extractUserId(token);
        updateInforUserService.updateUserProfile(userUpdateRequest, userId);
        return ResponseEntity.ok().body(new ApiResponse("succcess", "Hồ sơ người dùng đã được cập nhật."));
    }
}
