package com.hcmus.statisticservice.dto.request;

import java.util.Date;

import lombok.*;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class EditGoalRequest {
    private Date startingDate;

    private Double startingWeight;

    private Double currentWeight;

    private Double goalWeight;

    private Double weeklyGoal; 
    
    private String activitylevel;
}
