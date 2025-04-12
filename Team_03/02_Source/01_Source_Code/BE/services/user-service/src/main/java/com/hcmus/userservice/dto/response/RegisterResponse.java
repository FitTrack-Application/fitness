package com.hcmus.userservice.dto.response;

import com.hcmus.userservice.model.type.Role;
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

    private String email;

    private String name;

    private Role role;
}