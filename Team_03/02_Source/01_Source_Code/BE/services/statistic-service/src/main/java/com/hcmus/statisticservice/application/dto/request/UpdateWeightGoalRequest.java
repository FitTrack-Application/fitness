package com.hcmus.statisticservice.application.dto.request;

import lombok.*;

import java.util.Date;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class UpdateWeightGoalRequest {

    private Date startingDate;

    private Double startingWeight;

    private Double currentWeight;

    private Double goalWeight;

    private Double weeklyGoal;

    private String activityLevel;
}
