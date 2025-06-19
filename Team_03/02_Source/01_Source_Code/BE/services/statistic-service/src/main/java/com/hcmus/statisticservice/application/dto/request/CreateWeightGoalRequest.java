package com.hcmus.statisticservice.application.dto.request;

import jakarta.validation.constraints.Future;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CreateWeightGoalRequest {
    @NotNull(message = "Current weight cannot be empty")
    @Positive(message = "Current weight must be a positive number")
    private Double startWeight;

    @NotNull(message = "Target weight cannot be empty")
    @Positive(message = "Target weight must be a positive number")
    private Double targetWeight;

    @NotNull(message = "Start date cannot be empty")
    private LocalDate startDate;

    @NotNull(message = "Target date cannot be empty")
    @Future(message = "Target date must be in the future")
    private LocalDate targetDate;
}