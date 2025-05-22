package com.hcmus.chatbotservice.controller;

import com.hcmus.chatbotservice.service.GeminiService;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/chatbot")
public class ChatbotController {

    private final GeminiService geminiService;

    public ChatbotController(GeminiService geminiService) {
        this.geminiService = geminiService;
    }

    @PostMapping("/chat")
    public String chat(@RequestBody String prompt) {
        return geminiService.generateResponse(prompt);
    }
} 