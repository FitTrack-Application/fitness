package com.hcmus.chatbotservice.service;

import com.hcmus.chatbotservice.model.GeminiResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class GeminiService {

    @Value("${gemini.api.key}")
    private String apiKey;

    private final RestTemplate restTemplate;
    private static final String GEMINI_API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent";

    public GeminiService(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }

    public String generateResponse(String prompt) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        Map<String, Object> requestBody = new HashMap<>();
        Map<String, Object> content = new HashMap<>();
        Map<String, Object> part = new HashMap<>();
        part.put("text", prompt);
        content.put("parts", List.of(part));
        requestBody.put("contents", List.of(content));

        HttpEntity<Map<String, Object>> request = new HttpEntity<>(requestBody, headers);

        String url = GEMINI_API_URL + "?key=" + apiKey;
        GeminiResponse response = restTemplate.postForObject(url, request, GeminiResponse.class);

        if (response != null && 
            response.getCandidates() != null && 
            !response.getCandidates().isEmpty() &&
            response.getCandidates().get(0).getContent() != null &&
            !response.getCandidates().get(0).getContent().getParts().isEmpty()) {
            return response.getCandidates().get(0).getContent().getParts().get(0).getText();
        }
        
        return "Không thể tạo phản hồi";
    }
} 