package com.hcmus.fitservice.mapper.helper;

import com.hcmus.fitservice.model.Food;
import com.hcmus.fitservice.model.ServingUnit;

public class MacrosCalculatorHelper {

    public static Macros calculateMacros(Food food, ServingUnit servingUnit, Double numberOfServing) {
        double multiplier = servingUnit.getConversionToGrams() * numberOfServing / 100.0;

        return new Macros(
                (int) Math.round(food.getCaloriesPer100g() * multiplier),
                Math.round(food.getProteinPer100g() * multiplier * 100.0) / 100.0,
                Math.round(food.getCarbsPer100g() * multiplier * 100.0) / 100.0,
                Math.round(food.getFatPer100g() * multiplier * 100.0) / 100.0
        );
    }
}
