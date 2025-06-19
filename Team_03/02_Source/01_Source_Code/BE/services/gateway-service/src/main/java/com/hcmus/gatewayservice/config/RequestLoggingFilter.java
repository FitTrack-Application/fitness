package com.hcmus.gatewayservice.config;

import lombok.extern.slf4j.Slf4j;
import org.springframework.cloud.gateway.filter.GatewayFilterChain;
import org.springframework.cloud.gateway.filter.GlobalFilter;
import org.springframework.core.Ordered;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.UUID;

@Component
@Slf4j
public class RequestLoggingFilter implements GlobalFilter, Ordered {

    @Override
    public Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {
        String requestId = UUID.randomUUID().toString();
        String path = exchange.getRequest().getPath().toString();
        String method = exchange.getRequest().getMethod().toString();
        String userId = exchange.getRequest().getHeaders().getFirst("X-User-Id");

        log.info("[{}] Request at {}: method={}, path={}",
                requestId,
                LocalDateTime.now(ZoneId.of("Asia/Ho_Chi_Minh")),
                method,
                path);

        return chain.filter(exchange).doOnSuccess(v ->
                log.info("[{}] Response at {}: status={}, path={}",
                        requestId,
                        LocalDateTime.now(ZoneId.of("Asia/Ho_Chi_Minh")),
                        exchange.getResponse().getStatusCode(),
                        path)
        );
    }

    @Override
    public int getOrder() {
        return Ordered.LOWEST_PRECEDENCE;
    }
}