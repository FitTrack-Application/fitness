package com.hcmus.statisticserivce.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;
import lombok.*;

import java.time.LocalDate;
import java.util.UUID;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class FoodLogDto {

    private UUID foodLogId;

    @NotNull(message = "User ID cannot be null")
    private UUID userId;

    private UUID foodId;

    @NotNull(message = "Food item cannot be empty")
    @Size(max = 255, message = "Food item cannot exceed 255 characters")
    private String foodItem;

    @Positive(message = "Calories must be a positive number")
    private Double calories;

    @Positive(message = "Protein must be a positive number")
    private Double protein;

    @Positive(message = "Carbs must be a positive number")
    private Double carbs;

    @Positive(message = "Fat must be a positive number")
    private Double fat;

    @Positive(message = "Quantity must be a positive number")
    private Double quantity;

    @NotNull(message = "Date cannot be null")
    private LocalDate date;
}