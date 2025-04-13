package com.hcmus.fitservice.dto.request;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class MealEntryRequest {

    private UUID foodId;

    private String servingUnit;

    private Double numberOfServings;
}
