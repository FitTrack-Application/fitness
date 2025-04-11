package com.hcmus.userservice.dto.response;

import com.hcmus.userservice.model.Role;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class AuthResponse {

    private String token;

    private UUID userId;

    private UUID goalId;

    private String email;

    private String name;

    private Role role;

    private String message;

    public AuthResponse(String message) {
        this.message = message;
    }
}