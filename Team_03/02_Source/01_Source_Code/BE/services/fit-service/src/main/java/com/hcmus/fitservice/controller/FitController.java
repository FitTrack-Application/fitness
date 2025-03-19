package com.hcmus.fitservice.controller;

@RestController
@RequestMapping("/")
public class FitController {
    
    @GetMapping("test")
    public String testServer() {
        return "Test";
    }
}
