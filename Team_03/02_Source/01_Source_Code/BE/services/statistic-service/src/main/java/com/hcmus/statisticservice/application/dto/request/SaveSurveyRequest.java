package com.hcmus.statisticservice.application.dto.request;

import jakarta.validation.constraints.NotNull;
import lombok.*;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

@Setter
@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class SaveSurveyRequest {

    @NotNull(message = "Name cannot be null")
    private String name;

    @NotNull(message = "Age cannot be null")
    private Integer age;

    @NotNull(message = "Gender cannot be null")
    private String gender;

    @NotNull(message = "Height cannot be null")
    private Integer height;

    @NotNull(message = "Activity level cannot be null")
    private String activityLevel;

    private String imageUrl;

    private String goalType;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date startingDate;

    private Double goalWeight;

    private Double weeklyGoal;

    @NotNull(message = "Weight cannot be null")
    private Double weight;
}
