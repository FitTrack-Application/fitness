package com.hcmus.foodservice.dto.request;

import lombok.*;

import java.util.UUID;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AddRecipeToMealLogRequest {
    private UUID recipeId;

    private Double numberOfServings;
}
