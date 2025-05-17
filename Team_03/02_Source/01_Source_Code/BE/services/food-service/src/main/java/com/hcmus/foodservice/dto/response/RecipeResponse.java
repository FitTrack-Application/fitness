package com.hcmus.foodservice.dto.response;

import lombok.*;

import java.util.List;
import java.util.UUID;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RecipeResponse {
    private UUID id;

    private String name;

    private String direction;

    private List<FoodEntryResponse> recipeEntries;
}
