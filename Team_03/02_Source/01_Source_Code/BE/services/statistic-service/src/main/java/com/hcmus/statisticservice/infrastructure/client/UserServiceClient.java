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

    // Sử dụng giá trị mặc định thay vì @Value để tránh lỗi
    private String userServiceUrl = "http://user-service:8080";

    /**
     * Kiểm tra xem người dùng có tồn tại không
     * 
     * @param userId ID của người dùng
     * @return true nếu người dùng tồn tại
     */
    public boolean checkUserExists(UUID userId) {
        try {
            String url = userServiceUrl + "/api/users/" + userId + "/exists";
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
     * Lấy thông tin cơ bản của người dùng
     * 
     * @param userId ID của người dùng
     * @return Thông tin người dùng dưới dạng Map hoặc null nếu không tìm thấy
     */
    public Map<String, Object> getUserBasicInfo(UUID userId) {
        try {
            String url = userServiceUrl + "/api/users/" + userId + "/basic-info";
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