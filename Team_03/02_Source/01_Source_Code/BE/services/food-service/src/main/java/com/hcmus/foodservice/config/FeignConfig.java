package com.hcmus.foodservice.config;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.hcmus.foodservice.exception.ValidationException;
import com.hcmus.foodservice.util.CustomSecurityContextHolder;
import feign.FeignException;
import feign.RequestInterceptor;
import feign.codec.ErrorDecoder;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.UUID;

@Configuration
@Slf4j
public class FeignConfig {

    private static final List<String> excludedClients = new ArrayList<>(List.of("open-food-fact", "embedding-service"));

    private boolean checkExcludedClient(String client) {
        return excludedClients.contains(client);
    }

    @Bean
    public RequestInterceptor requestInterceptor() {
        return request -> {
            String clientName = request.feignTarget().name();
            if (checkExcludedClient(clientName)) {
                return;
            }
            try {
                UUID userId = Objects.requireNonNull(CustomSecurityContextHolder.getCurrentUserId());
                String roles = CustomSecurityContextHolder.getCurrentUserRolesAsString();
                request.header("X-User-Id", userId.toString());
                if (!roles.isEmpty()) {
                    request.header("X-User-Roles", roles);
                }
                log.info("Feign request headers added: userId={}, roles={}", userId, roles);
            } catch (Exception e) {
                log.warn("Failed to set feign headers: {}", e.getMessage());
            }
        };
    }

    @Bean
    public ErrorDecoder errorDecoder() {
        return (methodKey, response) -> {
            int status = response.status();
            String errorMessage = String.format("Feign error occurred: method=%s, status=%d", methodKey, status);
            log.error(errorMessage);
            try {
                String responseBody = response.body() != null ? new String(response.body().asInputStream().readAllBytes()) : "";
                if (status == 422) {
                    JsonNode errorResponse = new ObjectMapper().readTree(responseBody);
                    JsonNode details = errorResponse.get("detail");
                    if (details.isArray()) {
                        StringBuilder detailedMessage = new StringBuilder("Validation errors: ");
                        details.forEach(detail -> {
                            String msg = detail.get("msg").asText();
                            String loc = detail.get("loc").toString();
                            detailedMessage.append(String.format("location=%s, msg=%s; ", loc, msg));
                        });
                        return new ValidationException(detailedMessage.toString());
                    }
                }
                return new FeignException.FeignClientException(status, errorMessage, response.request(), responseBody.getBytes(), null);
            } catch (Exception e) {
                log.warn("Failed to parse error response: {}", e.getMessage());
                return new RuntimeException(errorMessage);
            }
        };
    }
}
