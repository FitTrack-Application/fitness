package com.hcmus.statisticserivce.dto;


import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.util.UUID;

import jakarta.validation.constraints.NotBlank;


@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class AddWeightRequest {
    @NotBlank(message = "UserId is required")
    private UUID userId;
    
    @NotBlank(message = "GoalId is required")
    private UUID goalId;


    @NotBlank(message = "Weight is required")
    private Double weight;

    @NotBlank(message = "UpdateDate is required")
    private LocalDate updateDate;

    
    private String progressPhoto;
    
}
