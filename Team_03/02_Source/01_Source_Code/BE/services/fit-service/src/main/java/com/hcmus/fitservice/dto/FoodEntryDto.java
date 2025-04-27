package com.hcmus.fitservice.dto;

import lombok.*;

import java.util.UUID;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class FoodEntryDto {
    private UUID id;

    private UUID foodId;

    private String servingUnit;

    private Double numberOfServings;
}
