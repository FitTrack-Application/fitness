package com.hcmus.fitservice.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class MealEntryDto {
    private UUID id;

    private UUID foodId;

    private String servingUnit;

    private Double numberOfServings;
}
