package com.hcmus.userservice.dto.response;

import com.hcmus.userservice.model.Role;
import lombok.*;

import java.util.UUID;

@Setter
@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class RegisterResponse {

    private String accessToken;

    private String refreshToken;

    private UUID userId;

    private UUID goalId;

    private String email;

    private String name;

    private Role role;
}