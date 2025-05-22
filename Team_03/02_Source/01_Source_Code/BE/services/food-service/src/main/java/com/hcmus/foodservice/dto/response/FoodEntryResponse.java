package com.hcmus.foodservice.dto.response;

import lombok.*;

import java.util.UUID;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class FoodEntryResponse {
    private UUID id;

    private UUID foodId;

    private ServingUnitResponse servingUnit;

    private Double numberOfServings;

    // Macros
    private Integer calories;

    private Double protein;

    private Double carbs;

    private Double fat;
}
