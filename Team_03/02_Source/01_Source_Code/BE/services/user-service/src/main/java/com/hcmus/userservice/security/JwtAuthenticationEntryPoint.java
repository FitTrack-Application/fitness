package com.hcmus.userservice.security;

import com.hcmus.userservice.dto.response.ApiResponse;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

@Component
public class JwtAuthenticationEntryPoint implements AuthenticationEntryPoint {

    @Override
    public void commence(HttpServletRequest request, HttpServletResponse response, AuthenticationException authException) throws IOException {
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        response.setContentType("application/json");
        ApiResponse<?> apiErrorResponse = ApiResponse.builder()
                .status(HttpStatus.UNAUTHORIZED.value())
                .generalMessage("Unauthorized at " + request.getRequestURI() + "!")
                .errorDetails(List.of(authException.getMessage()))
                .timestamp(LocalDateTime.now())
                .build();
        response.getWriter().write(apiErrorResponse.toJson());
    }
}