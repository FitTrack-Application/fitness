package com.hcmus.gatewayservice.config;

import lombok.extern.slf4j.Slf4j;
import org.springframework.cloud.gateway.filter.GatewayFilterChain;
import org.springframework.cloud.gateway.filter.GlobalFilter;
import org.springframework.http.server.reactive.ServerHttpRequest;
import org.springframework.security.oauth2.server.resource.authentication.BearerTokenAuthentication;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

import java.util.Collections;
import java.util.List;
import java.util.Map;

@Component
@Slf4j
public class TokenHeaderFilter implements GlobalFilter {

    @Override
    public Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {
        return exchange.getPrincipal()
                .ofType(BearerTokenAuthentication.class)
                .flatMap(auth -> {
                    Map<String, Object> attributes = auth.getTokenAttributes();
                    String userId = (String) attributes.getOrDefault("sub", "");
                    @SuppressWarnings("unchecked")
                    Map<String, Object> realmAccess = (Map<String, Object>) attributes.getOrDefault("realm_access", Collections.emptyMap());
                    @SuppressWarnings("unchecked")
                    List<String> roles = (List<String>) realmAccess.getOrDefault("roles", Collections.emptyList());
                    String roleHeader = String.join(",", roles);
                    ServerHttpRequest mutatedRequest = exchange.getRequest().mutate()
                            .header("X-User-Id", userId)
                            .header("X-User-Roles", roleHeader)
                            .build();
                    log.info("Token authenticated. Adding headers: X-User-Id={}, X-User-Roles={}", userId, roleHeader);
                    return chain.filter(exchange.mutate().request(mutatedRequest).build());
                })
                .switchIfEmpty(chain.filter(exchange));

    }
}
