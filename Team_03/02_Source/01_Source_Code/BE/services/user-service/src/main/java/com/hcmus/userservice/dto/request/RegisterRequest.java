package com.hcmus.userservice.dto.request;

import com.hcmus.userservice.model.type.Role;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.*;

import java.util.Date;

@Setter
@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class RegisterRequest {

    // profile

    private String name;

    private String email;

    private String password;

    private Integer age;

    private String gender;

    private Integer height;

    private Double weight;

    private String imageUrl;

    // goals

    private String goalType;

    private Date startingDate;

    private Double goalWeight;

    private Double weeklyGoal;

    private String activityLevel;
}
