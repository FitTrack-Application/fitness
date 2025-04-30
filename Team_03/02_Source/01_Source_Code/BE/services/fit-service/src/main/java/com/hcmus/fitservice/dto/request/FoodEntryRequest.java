package com.hcmus.fitservice.dto.request;

import lombok.*;

import java.util.UUID;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class FoodEntryRequest {

    private UUID foodId;

    private UUID servingUnitId;

    private Double numberOfServings;
}
