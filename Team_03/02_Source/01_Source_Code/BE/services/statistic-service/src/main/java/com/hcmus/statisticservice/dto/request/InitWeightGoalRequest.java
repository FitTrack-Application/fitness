package com.hcmus.statisticservice.dto.request;

import lombok.*;

import java.util.Date;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class InitWeightGoalRequest {

    private Double startingWeight;

    private Date startingDate;

    private Double goalWeight;

    private Double weeklyGoal;
}
