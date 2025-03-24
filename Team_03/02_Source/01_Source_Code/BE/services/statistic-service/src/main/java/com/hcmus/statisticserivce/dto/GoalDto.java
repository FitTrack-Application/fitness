package com.hcmus.statisticserivce.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;
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
public class GoalDto {
    private UUID goalId;

    @NotNull(message = "User ID cannot be null")
    private UUID userId;

    @NotNull(message = "Goal type cannot be empty")
    @Size(max = 100, message = "Goal type cannot exceed 100 characters")
    private String goalType;

    @Positive(message = "Target value must be a positive number")
    private Double targetValue;

    private Double currentValue;

    private Double progress;

    private LocalDate deadline;

    private Boolean achievedStatus;
}