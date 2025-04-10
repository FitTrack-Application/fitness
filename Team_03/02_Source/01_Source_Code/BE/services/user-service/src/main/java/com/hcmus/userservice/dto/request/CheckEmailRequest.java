package com.hcmus.userservice.dto.request;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class CheckEmailRequest {

    @Email(message = "Invalid email format")
    @NotBlank(message = "Email is required")
    private String email;

}