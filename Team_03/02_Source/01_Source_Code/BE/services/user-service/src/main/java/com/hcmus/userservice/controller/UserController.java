package com.hcmus.userservice.controller;

import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@AllArgsConstructor
@RestController
@RequestMapping("/api/user")
public class UserController {

    @GetMapping
    public ResponseEntity<?> testServer() {
        return ResponseEntity.ok("User service");
    }
}
