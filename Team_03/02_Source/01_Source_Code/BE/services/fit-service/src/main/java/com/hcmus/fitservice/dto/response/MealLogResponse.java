package com.hcmus.fitservice.dto.response;

import com.hcmus.fitservice.dto.FoodEntryDto;
import lombok.*;

import java.util.Date;
import java.util.List;
import java.util.UUID;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class MealLogResponse {
    private UUID id;

    private Date date;

    private String mealType;

    private List<FoodEntryDto> mealEntries;
}
