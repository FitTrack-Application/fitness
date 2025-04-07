package com.hcmus.userservice.dto;

import java.time.LocalDate;

import com.hcmus.userservice.model.Role;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class SurveyRequest {
    @NotBlank(message = "Name is required")
    private String name;

    private Integer age;

    private String gender;

    private Double height;

    private Double weight;

    private String imageUrl;

    private String goalType;

    private Double weightGoal;
    
    private Double goalPerWeek;

    private String activityLevel;

    private Double caloriesGoal;
}
