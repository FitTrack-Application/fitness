package com.hcmus.statisticserivce.controller;

import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@AllArgsConstructor
@RestController
@RequestMapping("/api/statistic")
public class StatisticController {

    @GetMapping("/")
    public ResponseEntity<?> testServer() {
        return ResponseEntity.ok("Statistic Service");
    }
}
