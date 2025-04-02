package com.hcmus.userservice.controller;

import com.hcmus.userservice.dto.SurveyResponse;
import com.hcmus.userservice.dto.SurveyRequest;
import com.hcmus.userservice.service.SurveyService;
import com.hcmus.userservice.utility.JwtUtil;

import lombok.AllArgsConstructor;
import jakarta.validation.Valid;

import java.util.UUID;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
@AllArgsConstructor
@RestController
@RequestMapping("/api/user")
public class UserController {

    private final SurveyService surveyService;
    private final JwtUtil jwtUtil;

    @GetMapping
    public ResponseEntity<?> testServer() {
        return ResponseEntity.ok("User service"); // demo
    }

    @PostMapping("/survey")
    public ResponseEntity<SurveyResponse> survey(@RequestBody SurveyRequest request, @RequestHeader("Authorization") String token) {
        String userIdStr = jwtUtil.extractUserId(token.replace("Bearer ", ""));
        UUID userId = UUID.fromString(userIdStr);
        return ResponseEntity.ok(surveyService.survey(request, userId));
    }

}

