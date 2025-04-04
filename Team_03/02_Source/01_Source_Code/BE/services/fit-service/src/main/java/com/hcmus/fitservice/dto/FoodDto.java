package com.hcmus.fitservice.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class FoodDto {
    private UUID id;
    private String name;
    private int caloriesPer100g;
    private double proteinPer100g;
    private double carbsPer100g;
    private double fatPer100g;
    private String imageUrl;
}
