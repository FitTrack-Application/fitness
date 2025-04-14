package com.hcmus.statisticservice.dto.request;

import lombok.*;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class InitCaloriesGoalRequest {
    private String gender;

    private Double weight;

    private Double height;

    private Integer age;

    private String activityLevel;

    private Double weeklyGoal;
    
    private String goalType;
}
