package com.hcmus.userservice.controller;

import com.hcmus.userservice.dto.SurveyResponse;
import com.hcmus.userservice.service.CustomUserDetailsService;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@AllArgsConstructor
@RestController
@RequestMapping("/api/user")
public class UserController {

    private final CustomUserDetailsService customUserDetailsService;

    @GetMapping
    public ResponseEntity<?> testServer() {
        return ResponseEntity.ok("User service"); // demo
    }

    @PostMapping("/survey")
    public ResponseEntity<SurveyResponse> survey(@RequestBody @Valid SurveyRequest request) {
        return ResponseEntity.ok(customUserDetailsService.survey(request));
    }

}

