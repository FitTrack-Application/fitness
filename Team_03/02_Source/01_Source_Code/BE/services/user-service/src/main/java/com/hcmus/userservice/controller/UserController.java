package com.hcmus.userservice.controller;

import com.hcmus.userservice.dto.SurveyResponse;
import com.hcmus.userservice.dto.SurveyRequest;
import com.hcmus.userservice.service.SurveyService;

import lombok.AllArgsConstructor;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

@AllArgsConstructor
@RestController
@RequestMapping("/api/user")
public class UserController {

    private final SurveyService surveyService;

    @GetMapping
    public ResponseEntity<?> testServer() {
        return ResponseEntity.ok("User service"); // demo
    }

    @PostMapping("/survey")
    public ResponseEntity<SurveyResponse> survey(@RequestBody @Valid SurveyRequest request) {
        return ResponseEntity.ok(surveyService.survey(request));
    }

}

