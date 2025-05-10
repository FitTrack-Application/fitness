package com.hcmus.statisticservice.application.dto.request;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AddWeightLogRequest {
    @NotNull(message = "Weight cannot be empty")
    @Positive(message = "Weight must be a positive number")
    private Double weight;

    private String imageUrl;
}