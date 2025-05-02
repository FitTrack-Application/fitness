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
    @NotNull(message = "Cân nặng không được để trống")
    @Positive(message = "Cân nặng phải là số dương")
    private Double weight;

    private String imageUrl;
}