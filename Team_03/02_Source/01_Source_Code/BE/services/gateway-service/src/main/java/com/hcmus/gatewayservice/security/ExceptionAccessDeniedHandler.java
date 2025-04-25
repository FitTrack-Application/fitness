package com.hcmus.gatewayservice.security;

import com.hcmus.gatewayservice.dto.response.ApiResponse;
import org.springframework.core.io.buffer.DataBuffer;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.web.server.authorization.ServerAccessDeniedHandler;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.util.List;

@Component
public class ExceptionAccessDeniedHandler implements ServerAccessDeniedHandler {

    @Override
    public Mono<Void> handle(ServerWebExchange exchange, AccessDeniedException denied) {
        ApiResponse<Object> response = ApiResponse.builder()
                .status(403)
                .generalMessage("Forbidden")
                .errorDetails(List.of("[GW] You do not have permission to access this resource."))
                .timestamp(LocalDateTime.now())
                .build();

        byte[] bytes = response.toJson().getBytes(StandardCharsets.UTF_8);
        exchange.getResponse().setStatusCode(HttpStatus.OK); // always return 200
        exchange.getResponse().getHeaders().setContentType(MediaType.APPLICATION_JSON);
        DataBuffer buffer = exchange.getResponse().bufferFactory().wrap(bytes);

        return exchange.getResponse().writeWith(Mono.just(buffer));
    }
}
