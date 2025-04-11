package com.hcmus.userservice.dto.response;

import com.hcmus.userservice.model.Role;
import lombok.*;

import java.util.UUID;

@Setter
@Getter
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