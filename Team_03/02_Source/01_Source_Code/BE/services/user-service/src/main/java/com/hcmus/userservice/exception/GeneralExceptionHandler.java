package com.hcmus.userservice.exception;

import com.hcmus.userservice.controller.AuthController;
import com.hcmus.userservice.dto.response.ApiResponse;
import org.springframework.security.core.AuthenticationException;
import org.springframework.validation.FieldError;
import org.springframework.boot.context.config.ConfigDataResourceNotFoundException;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.web.HttpRequestMethodNotSupportedException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;
import org.springframework.web.servlet.resource.NoResourceFoundException;

import java.time.LocalDateTime;
import java.util.List;

@Order(Ordered.HIGHEST_PRECEDENCE)
@RestControllerAdvice(basePackageClasses = {
        AuthController.class
})
public class GeneralExceptionHandler {

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ApiResponse<?>> handleValidationErrors(MethodArgumentNotValidException ex) {
        List<String> errors = ex.getBindingResult().getFieldErrors().stream().map(FieldError::getDefaultMessage).toList();
        final ApiResponse<?> response = ApiResponse.builder()
                .status(HttpStatus.BAD_REQUEST.value())
                .generalMessage("Validation error!")
                .errorDetails(errors)
                .timestamp(LocalDateTime.now())
                .build();
        return ResponseEntity.ok(response);
    }

    @ExceptionHandler(AuthenticationException.class)
    public ResponseEntity<ApiResponse<?>> handleAuthenticationException(AuthenticationException ex, WebRequest request) {
        final ApiResponse<?> response = ApiResponse.builder()
                .status(HttpStatus.UNAUTHORIZED.value())
                .generalMessage("Authentication failed!")
                .errorDetails(List.of(ex.getMessage()))
                .timestamp(LocalDateTime.now())
                .build();
        return ResponseEntity.ok(response);
    }

    @ExceptionHandler(UserNotFoundException.class)
    ResponseEntity<ApiResponse<?>> handleUserNotFoundException(UserNotFoundException exception, WebRequest request) {
        final ApiResponse<?> response = ApiResponse.builder()
                .status(HttpStatus.BAD_REQUEST.value())
                .generalMessage("User not found!")
                .errorDetails(List.of(exception.getMessage()))
                .timestamp(LocalDateTime.now())
                .build();
        return ResponseEntity.ok(response);
    }

    @ExceptionHandler(InvalidTokenException.class)
    ResponseEntity<ApiResponse<?>> handleInvalidTokenException(InvalidTokenException exception, WebRequest request) {
        final ApiResponse<?> response = ApiResponse.builder()
                .status(HttpStatus.UNAUTHORIZED.value())
                .generalMessage("Invalid token!")
                .errorDetails(List.of(exception.getMessage()))
                .timestamp(LocalDateTime.now())
                .build();
        return ResponseEntity.ok(response);
    }

    @ExceptionHandler(BadCredentialsException.class)
    ResponseEntity<ApiResponse<?>> handleLoginException(BadCredentialsException exception, WebRequest request) {
        final ApiResponse<?> response = ApiResponse.builder()
                .status(HttpStatus.BAD_REQUEST.value())
                .generalMessage("Invalid username or password!")
                .errorDetails(List.of(exception.getMessage()))
                .timestamp(LocalDateTime.now())
                .build();
        return ResponseEntity.ok(response);
    }

    @ExceptionHandler(AccessDeniedException.class)
    public ResponseEntity<ApiResponse<?>> handleAccessDeniedException(AccessDeniedException ex, WebRequest request) {
        final ApiResponse<?> response = ApiResponse.builder()
                .status(HttpStatus.FORBIDDEN.value())
                .generalMessage("You do not have permission to access this resource.")
                .errorDetails(List.of(ex.getMessage()))
                .timestamp(LocalDateTime.now())
                .build();
        return ResponseEntity.ok(response);
    }

    @ExceptionHandler(HttpMessageNotReadableException.class)
    public ResponseEntity<ApiResponse<?>> handleHttpMessageNotReadableException(HttpMessageNotReadableException ex, WebRequest request) {
        final ApiResponse<?> apiErrorResponse = ApiResponse.builder()
                .status(HttpStatus.BAD_REQUEST.value())
                .generalMessage("Request body is missing or malformed!")
                .errorDetails(List.of(ex.getMessage()))
                .timestamp(LocalDateTime.now())
                .build();
        return ResponseEntity.ok(apiErrorResponse);
    }

    @ExceptionHandler(ConfigDataResourceNotFoundException.class)
    public ResponseEntity<ApiResponse<?>> handleResourceNotFoundException(ConfigDataResourceNotFoundException ex, WebRequest request) {
        final ApiResponse<?> response = ApiResponse.builder()
                .status(HttpStatus.NOT_FOUND.value())
                .generalMessage("Resource not found!")
                .errorDetails(List.of(ex.getMessage()))
                .timestamp(LocalDateTime.now())
                .build();
        return ResponseEntity.ok(response);
    }

    @ExceptionHandler(NoResourceFoundException.class)
    public ResponseEntity<ApiResponse<?>> handleNoResourceFoundException(NoResourceFoundException ex, WebRequest request) {
        final ApiResponse<?> response = ApiResponse.builder()
                .status(HttpStatus.NOT_FOUND.value())
                .generalMessage("Resource not found!")
                .errorDetails(List.of(ex.getMessage()))
                .timestamp(LocalDateTime.now())
                .build();
        return ResponseEntity.ok(response);
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<ApiResponse<?>> handleIllegalArgumentException(IllegalArgumentException ex, WebRequest request) {
        final ApiResponse<?> response = ApiResponse.builder()
                .status(HttpStatus.BAD_REQUEST.value())
                .generalMessage("Incorrect email or password!")
                .errorDetails(List.of(ex.getMessage()))
                .timestamp(LocalDateTime.now())
                .build();
        return ResponseEntity.ok(response);
    }

    @ExceptionHandler(MethodArgumentTypeMismatchException.class)
    public ResponseEntity<ApiResponse<?>> handleMethodArgumentTypeMismatchException(MethodArgumentTypeMismatchException ex, WebRequest request) {
        final ApiResponse<?> response = ApiResponse.builder()
                .status(HttpStatus.BAD_REQUEST.value())
                .generalMessage("Invalid argument type!")
                .errorDetails(List.of(ex.getMessage()))
                .timestamp(LocalDateTime.now())
                .build();
        return ResponseEntity.ok(response);
    }

    @ExceptionHandler(HttpRequestMethodNotSupportedException.class)
    public ResponseEntity<ApiResponse<?>> handleMethodNotSupported(HttpRequestMethodNotSupportedException ex, WebRequest request) {
        final ApiResponse<?> response = ApiResponse.builder()
                .status(HttpStatus.METHOD_NOT_ALLOWED.value())
                .generalMessage("HTTP method " + ex.getMethod() + " is not supported for this endpoint.")
                .errorDetails(List.of(ex.getMessage()))
                .timestamp(LocalDateTime.now())
                .build();
        return ResponseEntity.ok(response);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ApiResponse<?>> handleGlobalException(Exception ex, WebRequest request) {
        final ApiResponse<?> response = ApiResponse.builder()
                .status(HttpStatus.INTERNAL_SERVER_ERROR.value())
                .generalMessage("An unexpected error occurred. Please try again later.")
                .errorDetails(List.of(ex.getMessage()))
                .timestamp(LocalDateTime.now())
                .build();
        return ResponseEntity.ok(response);
    }
}
