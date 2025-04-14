package com.hcmus.fitservice.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Builder
@Data
public class NutrimentsDto {
    private double energy_kcal_100g;
    private double fat_100g;
    private double proteins_100g;
    private double carbohydrates_100g;
}
