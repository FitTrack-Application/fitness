package com.hcmus.fitservice.dto.response;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.util.UUID;


@Getter
@Setter
@Builder
public class FoodMacrosDetailsResponse {
    private UUID id;

    private String name;

    private String imageUrl;

    private String servingUnit;

    private Double numberOfServings;
    // Macros
    private Integer calories;

    private Double protein;

    private Double carbs;

    private Double fat;
}
