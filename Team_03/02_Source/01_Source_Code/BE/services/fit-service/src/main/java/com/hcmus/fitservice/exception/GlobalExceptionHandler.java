package com.hcmus.fitservice.exception;

import com.hcmus.fitservice.dto.response.ApiResponse;
import org.springframework.boot.context.config.ConfigDataResourceNotFoundException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.validation.FieldError;
import org.springframework.web.HttpRequestMethodNotSupportedException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;
import org.springframework.web.servlet.resource.NoResourceFoundException;

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

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ApiResponse<?>> handleValidationErrors(MethodArgumentNotValidException exception) {
        List<String> errors = exception.getBindingResult().getFieldErrors()
                .stream()
                .map(FieldError::getDefaultMessage)
                .toList();
        final ApiResponse<?> response = ApiResponse.builder()
                .status(HttpStatus.BAD_REQUEST.value())
                .generalMessage("Validation error!")
                .errorDetails(errors)
                .timestamp(LocalDateTime.now())
                .build();
        return ResponseEntity.ok(response);
    }

    @ExceptionHandler(InvalidTokenException.class)
    ResponseEntity<ApiResponse<?>> handleInvalidTokenException(InvalidTokenException exception) {
        final ApiResponse<?> response = ApiResponse.builder()
                .status(HttpStatus.UNAUTHORIZED.value())
                .generalMessage("Invalid token!")
                .errorDetails(List.of(exception.getMessage()))
                .timestamp(LocalDateTime.now())
                .build();
        return ResponseEntity.ok(response);
    }

    @ExceptionHandler(HttpMessageNotReadableException.class)
    public ResponseEntity<ApiResponse<?>> handleHttpMessageNotReadableException(HttpMessageNotReadableException exception) {
        final ApiResponse<?> apiErrorResponse = ApiResponse.builder()
                .status(HttpStatus.BAD_REQUEST.value())
                .generalMessage("Request body is missing or malformed!")
                .errorDetails(List.of(exception.getMessage()))
                .timestamp(LocalDateTime.now())
                .build();
        return ResponseEntity.ok(apiErrorResponse);
    }

    @ExceptionHandler(ConfigDataResourceNotFoundException.class)
    public ResponseEntity<ApiResponse<?>> handleResourceNotFoundException(ConfigDataResourceNotFoundException exception) {
        final ApiResponse<?> response = ApiResponse.builder()
                .status(HttpStatus.NOT_FOUND.value())
                .generalMessage("Resource not found!")
                .errorDetails(List.of(exception.getMessage()))
                .timestamp(LocalDateTime.now())
                .build();
        return ResponseEntity.ok(response);
    }

    @ExceptionHandler(NoResourceFoundException.class)
    public ResponseEntity<ApiResponse<?>> handleNoResourceFoundException(NoResourceFoundException exception) {
        final ApiResponse<?> response = ApiResponse.builder()
                .status(HttpStatus.NOT_FOUND.value())
                .generalMessage("Resource not found!")
                .errorDetails(List.of(exception.getMessage()))
                .timestamp(LocalDateTime.now())
                .build();
        return ResponseEntity.ok(response);
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<ApiResponse<?>> handleIllegalArgumentException(IllegalArgumentException exception) {
        final ApiResponse<?> response = ApiResponse.builder()
                .status(HttpStatus.BAD_REQUEST.value())
                .generalMessage("Incorrect email or password!")
                .errorDetails(List.of(exception.getMessage()))
                .timestamp(LocalDateTime.now())
                .build();
        return ResponseEntity.ok(response);
    }

    @ExceptionHandler(MethodArgumentTypeMismatchException.class)
    public ResponseEntity<ApiResponse<?>> handleMethodArgumentTypeMismatchException(MethodArgumentTypeMismatchException exception) {
        final ApiResponse<?> response = ApiResponse.builder()
                .status(HttpStatus.BAD_REQUEST.value())
                .generalMessage("Invalid argument type!")
                .errorDetails(List.of(exception.getMessage()))
                .timestamp(LocalDateTime.now())
                .build();
        return ResponseEntity.ok(response);
    }

    @ExceptionHandler(HttpRequestMethodNotSupportedException.class)
    public ResponseEntity<ApiResponse<?>> handleMethodNotSupported(HttpRequestMethodNotSupportedException exception) {
        final ApiResponse<?> response = ApiResponse.builder()
                .status(HttpStatus.METHOD_NOT_ALLOWED.value())
                .generalMessage("HTTP method " + exception.getMethod() + " is not supported for this endpoint!")
                .errorDetails(List.of(exception.getMessage()))
                .timestamp(LocalDateTime.now())
                .build();
        return ResponseEntity.ok(response);
    }

    @ExceptionHandler(RuntimeException.class)
    public ResponseEntity<ApiResponse<?>> handleGlobalException(RuntimeException exception) {
        final ApiResponse<?> response = ApiResponse.builder()
                .status(HttpStatus.INTERNAL_SERVER_ERROR.value())
                .generalMessage("An unexpected error occurred. Please try again later!")
                .errorDetails(List.of(exception.getMessage()))
                .timestamp(LocalDateTime.now())
                .build();
        return ResponseEntity.ok(response);
    }
}
