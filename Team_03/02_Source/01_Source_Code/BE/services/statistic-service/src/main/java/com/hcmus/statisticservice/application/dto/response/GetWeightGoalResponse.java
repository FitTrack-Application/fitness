package com.hcmus.statisticservice.application.dto.response;

import lombok.*;

import java.util.Date;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class GetWeightGoalResponse {

    private Date startingDate;

    private Double startingWeight;

    private Double currentWeight;

    private Double goalWeight;

    private Double weeklyGoal;

    private String activityLevel;
}
