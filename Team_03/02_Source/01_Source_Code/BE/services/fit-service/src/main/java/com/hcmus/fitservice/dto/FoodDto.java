package com.hcmus.fitservice.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class FoodDto {
    private UUID foodId;

    @NotNull(message = "Food name cannot be empty")
    @Size(max = 255, message = "Food name cannot exceed 255 characters")
    private String foodName;

    @NotNull(message = "Calories cannot be empty")
    @Positive(message = "Calories must be a positive number")
    private Double calories;

    @Positive(message = "Protein must be a positive number")
    private Double protein;

    @Positive(message = "Carbs must be a positive number")
    private Double carbs;

    @Positive(message = "Fat must be a positive number")
    private Double fat;
}