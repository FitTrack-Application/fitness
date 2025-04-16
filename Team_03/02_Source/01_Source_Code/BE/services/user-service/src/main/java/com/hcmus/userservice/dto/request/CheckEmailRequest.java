package com.hcmus.userservice.dto.request;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.*;

@Setter
@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class CheckEmailRequest {

    @Email(message = "Invalid email format")
    @NotBlank(message = "Email is required")
    private String email;
}