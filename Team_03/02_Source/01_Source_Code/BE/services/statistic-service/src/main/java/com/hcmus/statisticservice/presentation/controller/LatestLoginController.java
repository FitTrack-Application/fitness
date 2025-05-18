package com.hcmus.statisticservice.presentation.controller;

import com.hcmus.statisticservice.application.dto.response.ApiResponse;
import com.hcmus.statisticservice.application.service.LatestLoginService;
import com.hcmus.statisticservice.infrastructure.security.CustomSecurityContextHolder;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RequiredArgsConstructor
@RestController
@Slf4j
@RequestMapping("/api/latest-logins")
public class LatestLoginController {
    private final LatestLoginService latestLoginService;

    @PostMapping("/me")
    public ResponseEntity<ApiResponse<?>> updateLatestLogin() {

        UUID userId = CustomSecurityContextHolder.getCurrentUserId();
        log.info("Update latest login for user: {}", userId);
        ApiResponse<?> response = latestLoginService.updateLatestLogin(userId);

        return ResponseEntity.ok(response);
    }
    
}
