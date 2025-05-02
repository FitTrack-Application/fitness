package com.hcmus.statisticservice.application.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class WeightGoalResponse {
    private UUID id;
    private Double startWeight;
    private Double targetWeight;
    private Double currentWeight;
    private LocalDate startDate;
    private LocalDate targetDate;
    private String status;
    private Double progressPercentage;
    private Long estimatedDaysToTarget;
}