package com.hcmus.userservice.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.*;

@Setter
@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class RefreshRequest {

    @NotBlank(message = "Refresh token is required")
    private String refreshToken;
}