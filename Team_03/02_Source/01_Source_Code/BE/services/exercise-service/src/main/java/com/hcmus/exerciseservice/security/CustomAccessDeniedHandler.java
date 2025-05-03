package com.hcmus.exerciseservice.security;

import com.hcmus.exerciseservice.dto.response.ApiResponse;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.web.access.AccessDeniedHandler;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.List;

@Component
@Slf4j
public class CustomAccessDeniedHandler implements AccessDeniedHandler {

    @Override
    public void handle(HttpServletRequest request, HttpServletResponse response, AccessDeniedException exception) throws IOException, ServletException {
        log.warn("Forbidden error: {} | URI: {} | Method: {} | Headers: {}",
                exception.getMessage(), request.getRequestURI(), request.getMethod(), request.getHeaderNames());
        response.setStatus(HttpServletResponse.SC_OK);
        response.setContentType("application/json");
        ApiResponse<?> apiErrorResponse = ApiResponse.builder()
                .status(HttpStatus.FORBIDDEN.value())
                .generalMessage("[Exercise Service] Access Denied at " + request.getRequestURI() + "!")
                .errorDetails(List.of(exception.getMessage()))
                .timestamp(LocalDateTime.now(ZoneId.of("UTC+7")))
                .build();
        response.getWriter().write(apiErrorResponse.toJson());
    }
}
