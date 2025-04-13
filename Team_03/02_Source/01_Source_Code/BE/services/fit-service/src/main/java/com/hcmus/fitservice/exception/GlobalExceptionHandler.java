package com.hcmus.fitservice.exception;

import com.hcmus.fitservice.dto.response.ApiResponse;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.time.LocalDateTime;
import java.util.List;

@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(ResourceNotFoundException.class)
   public ResponseEntity<ApiResponse<?>> handleResourceNotFoundException(ResourceNotFoundException exception) {
        final ApiResponse<?> response = ApiResponse.builder()
                .status(HttpStatus.BAD_REQUEST.value())
                .generalMessage("Resource not found!")
                .errorDetails(List.of(exception.getMessage()))
                .timestamp(LocalDateTime.now())
                .build();
        return ResponseEntity.badRequest().body(response);
    }

    @ExceptionHandler(ResourceAlreadyExistsException.class)
    public ResponseEntity<ApiResponse<?>> handleResourceAlreadyExistsException(ResourceAlreadyExistsException exception) {
        final ApiResponse<?> response = ApiResponse.builder()
                .status(HttpStatus.BAD_REQUEST.value())
                .generalMessage("Resource already exists!")
                .errorDetails(List.of(exception.getMessage()))
                .timestamp(LocalDateTime.now())
                .build();
        return ResponseEntity.badRequest().body(response);
    }
}
