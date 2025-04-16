package com.hcmus.userservice.dto.request;

import lombok.*;
import org.springframework.format.annotation.DateTimeFormat;

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

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date startingDate;

    private Double goalWeight;

    private Double weeklyGoal;

    private String activityLevel;
}
