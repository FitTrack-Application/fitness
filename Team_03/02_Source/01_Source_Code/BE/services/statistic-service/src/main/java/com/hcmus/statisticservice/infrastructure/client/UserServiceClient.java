package com.hcmus.statisticservice.infrastructure.client;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import java.util.Map;
import java.util.UUID;

@Component
@RequiredArgsConstructor
@Slf4j
public class UserServiceClient {

    private final RestTemplate restTemplate;

    @Value("${app.gateway-service.host:http://gateway-service:8088}")
    private String gatewayServiceHost;

    /**
     * Check if a user exists
     * 
     * @param userId User ID to check
     * @return true if the user exists
     */
    public boolean checkUserExists(UUID userId) {
        try {
            String url = gatewayServiceHost + "/api/users/" + userId + "/exists";
            ResponseEntity<Map> response = restTemplate.getForEntity(url, Map.class);

            if (response.getStatusCode() == HttpStatus.OK && response.getBody() != null) {
                return Boolean.TRUE.equals(response.getBody().get("exists"));
            }
            return false;
        } catch (Exception e) {
            log.error("Error checking if user exists: {}", e.getMessage(), e);
            return false;
        }
    }

    /**
     * Get basic user information
     * 
     * @param userId User ID
     * @return User information as a Map or null if not found
     */
    public Map<String, Object> getUserBasicInfo(UUID userId) {
        try {
            String url = gatewayServiceHost + "/api/users/" + userId + "/basic-info";
            ResponseEntity<Map> response = restTemplate.getForEntity(url, Map.class);

            if (response.getStatusCode() == HttpStatus.OK && response.getBody() != null) {
                return response.getBody();
            }
            return null;
        } catch (Exception e) {
            log.error("Error getting user basic info: {}", e.getMessage(), e);
            return null;
        }
    }
}