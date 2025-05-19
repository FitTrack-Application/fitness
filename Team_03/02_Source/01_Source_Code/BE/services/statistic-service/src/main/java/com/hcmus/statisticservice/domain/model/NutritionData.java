package com.hcmus.statisticservice.domain.model;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class NutritionData {

    private int calories;

    private double protein;

    private double fat;

    private double carbs;
}