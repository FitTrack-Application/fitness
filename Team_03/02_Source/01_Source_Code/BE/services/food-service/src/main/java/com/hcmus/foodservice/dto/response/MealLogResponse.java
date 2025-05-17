package com.hcmus.foodservice.dto.response;

import lombok.*;

import java.util.Date;
import java.util.List;
import java.util.UUID;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MealLogResponse {
    private UUID id;

    private Date date;

    private String mealType;

    private List<FoodEntryResponse> mealEntries;
}
