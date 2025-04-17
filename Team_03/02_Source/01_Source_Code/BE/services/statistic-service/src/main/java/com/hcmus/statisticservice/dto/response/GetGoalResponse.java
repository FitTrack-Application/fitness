package com.hcmus.statisticservice.dto.response;

import java.util.Date;

import lombok.*;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class GetGoalResponse {
    private Date startingDate;

    private Double startingWeight;

    private Double currentWeight;

    private Double goalWeight;

    private Double weeklyGoal;
    
    private String  activityLevel;
}
