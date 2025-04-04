package com.hcmus.userservice.controller;

import com.hcmus.userservice.dto.request.LoginRequest;
import com.hcmus.userservice.dto.response.ApiResponse;
import com.hcmus.userservice.dto.response.AuthResponse;
import com.hcmus.userservice.dto.request.RegisterRequest;
import com.hcmus.userservice.dto.response.LoginResponse;
import com.hcmus.userservice.service.AuthService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import java.util.Map;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody @Valid RegisterRequest request) {
        try {
            return ResponseEntity.ok(authService.register(request));
        } catch (ResponseStatusException e) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body(
                    Map.of("status", "error", "message", "Email is already exist or invalid information"));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(
                    Map.of("status", "error", "message", e.getMessage()));
        }
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody @Valid LoginRequest request) {
        try {
            return ResponseEntity.ok(authService.login(request));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(
                    Map.of("status", "error", "message", e.getMessage()));
        }
    }
}