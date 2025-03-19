package com.hcmus.fitservice.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class FitController {

    @GetMapping("test")
    public String testServer() {
        return "Test";
    }
}
