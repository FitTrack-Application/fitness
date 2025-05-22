package com.hcmus.foodservice.dto.response;

import lombok.*;

import java.util.UUID;


@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class FoodMacrosDetailsResponse {
    private UUID id;

    private String name;

    private String imageUrl;

    private ServingUnitResponse servingUnit;

    private Double numberOfServings;
    // Macros
    private Integer calories;

    private Double protein;

    private Double carbs;

    private Double fat;
}
