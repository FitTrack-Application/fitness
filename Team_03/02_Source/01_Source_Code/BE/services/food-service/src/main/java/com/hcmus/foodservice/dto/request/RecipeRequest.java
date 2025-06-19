package com.hcmus.foodservice.dto.request;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class RecipeRequest {
    private String name;

    private String direction;

    private List<FoodEntryRequest> recipeEntries;
}
