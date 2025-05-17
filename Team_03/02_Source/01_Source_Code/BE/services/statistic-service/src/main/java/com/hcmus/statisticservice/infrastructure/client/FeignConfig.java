package com.hcmus.statisticservice.infrastructure.client;

import com.hcmus.statisticservice.infrastructure.security.CustomSecurityContextHolder;
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

    private static final List<String> excludedClients = new ArrayList<>(List.of());

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
            return new RuntimeException(errorMessage);
        };
    }
}
