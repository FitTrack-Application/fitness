package com.hcmus.userservice.dto.request;

import com.hcmus.userservice.model.type.Role;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.*;

@Setter
@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class RegisterRequest {

    @NotBlank(message = "Name is required")
    private String name;

    @Email(message = "Invalid email format")
    @NotBlank(message = "Email is required")
    private String email;

    @NotBlank(message = "Password is required")
    @Size(min = 6, message = "Password must be at least 6 characters")
    private String password;

    private Integer age;

    private String gender;

    private Integer height;

    private Double weight;

    private String imageUrl;

    private Role role;

    private String goalType;

    private Double weightGoal;

    private Double goalPerWeek;

    private String activityLevel;

    private Double caloriesGoal;
}
