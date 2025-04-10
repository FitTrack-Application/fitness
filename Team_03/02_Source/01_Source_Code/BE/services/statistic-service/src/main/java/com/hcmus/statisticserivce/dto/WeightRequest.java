package com.hcmus.statisticserivce.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

import jakarta.validation.constraints.NotBlank;


@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class WeightRequest {
    @NotBlank(message = "UserId is required")
    private UUID userId;
    
    @NotBlank(message = "GoalId is required")
    private UUID goalId;
}
