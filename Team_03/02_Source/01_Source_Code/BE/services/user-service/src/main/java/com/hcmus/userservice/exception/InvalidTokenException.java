package com.hcmus.userservice.exception;

public class InvalidTokenException extends RuntimeException {
    public InvalidTokenException(final String message) {
        super(message);
    }
}
