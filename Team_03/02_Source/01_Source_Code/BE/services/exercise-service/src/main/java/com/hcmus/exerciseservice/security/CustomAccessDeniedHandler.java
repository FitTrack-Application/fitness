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

@Slf4j
@Component
public class CustomAccessDeniedHandler implements AccessDeniedHandler {

    @Override
    public void handle(HttpServletRequest request, HttpServletResponse response, AccessDeniedException exception) throws IOException, ServletException {
        log.warn("Forbidden error: {}", exception.getMessage());
        response.setStatus(HttpServletResponse.SC_FORBIDDEN);
        response.setContentType("application/json");
        ApiResponse<?> apiErrorResponse = ApiResponse.builder()
                .status(HttpStatus.FORBIDDEN.value())
                .generalMessage("[Exercise Service] Access denied at " + request.getRequestURI() + "!")
                .build();
        response.getWriter().write(apiErrorResponse.toJson());
    }
}
