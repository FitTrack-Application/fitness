package com.hcmus.fitservice.controller;

import com.hcmus.fitservice.dto.TestDto;
import com.hcmus.fitservice.service.TestService;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@AllArgsConstructor
@RestController
@RequestMapping("/api/fit")
public class FitController {

    private final TestService testService;

    @GetMapping("/")
    public ResponseEntity<TestDto> testServer01() {
        TestDto testDto = testService.testServer();
        if (testDto == null) {
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.ok(testDto);
    }

    @GetMapping("/test")
    public ResponseEntity<?> testServer02() {
        return ResponseEntity.ok("Fitness Service");
    }
}
