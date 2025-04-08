package com.hcmus.fitservice.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class MealEntryRequestDto {
    private UUID foodId;

    private String servingUnit;

    private Integer numberOfServings;
}
