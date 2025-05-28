package com.hcmus.statisticservice.application.dto.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.Builder;


@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class DashboardResponse {
    private Integer caloriesGoal;
    private Double totalCaloriesConsumed;
    private Integer totalCaloriesBurned;
}
