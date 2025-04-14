package com.hcmus.userservice.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.*;

@Setter
@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class VerifyRequest {

    @NotBlank(message = "Token is required")
    private String token;
}