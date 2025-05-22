package com.hcmus.statisticservice.application.dto.request;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;
import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
public class FoodRequest {

    @NotNull(message = "Food name cannot be empty")
    @Size(max = 255, message = "Food name cannot exceed 255 characters")
    private String name;

    @NotNull(message = "Calories cannot be empty")
    @Positive(message = "Calories must be a positive number")
    private Integer calories;

    @NotNull(message = "Protein cannot be empty")
    @Positive(message = "Protein must be a positive number")
    private Double protein;

    @NotNull(message = "Carbs cannot be empty")
    @Positive(message = "Carbs must be a positive number")
    private Double carbs;

    @NotNull(message = "Fat cannot be empty")
    @Positive(message = "Fat must be a positive number")
    private Double fat;

    private String imageUrl;
}
