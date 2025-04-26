package com.hcmus.statisticservice.security;

import com.hcmus.statisticservice.dto.response.ApiResponse;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.web.access.AccessDeniedHandler;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

@Component
public class ExceptionAccessDeniedHandler implements AccessDeniedHandler {

    @Override
    public void handle(HttpServletRequest request, HttpServletResponse response, AccessDeniedException accessDeniedException) throws IOException, ServletException {
        response.setStatus(HttpServletResponse.SC_OK);
        response.setContentType("application/json");
        ApiResponse<?> apiErrorResponse = ApiResponse.builder()
                .status(HttpStatus.FORBIDDEN.value())
                .generalMessage("Access Denied at " + request.getRequestURI() + "!")
                .errorDetails(List.of(accessDeniedException.getMessage()))
                .timestamp(LocalDateTime.now())
                .build();
        response.getWriter().write(apiErrorResponse.toJson());
    }
}
