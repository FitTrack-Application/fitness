package com.hcmus.fitservice.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;
import java.util.List;
import java.util.UUID;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class MealLogDto {
    private UUID id;

    private Date date;

    private String mealType;

    private List<MealEntryDto> mealEntries;
}
