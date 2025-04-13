package com.hcmus.fitservice.service;

import com.hcmus.fitservice.dto.MealEntryDto;
import com.hcmus.fitservice.model.Food;
import com.hcmus.fitservice.model.MealEntry;
import com.hcmus.fitservice.model.type.ServingUnit;
import com.hcmus.fitservice.repository.FoodRepository;
import com.hcmus.fitservice.repository.MealEntryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
public class MealEntryServiceImpl implements MealEntryService {
    private final MealEntryRepository mealEntryRepository;

    private final FoodRepository foodRepository;

    @Autowired
    public MealEntryServiceImpl(MealEntryRepository mealEntryRepository, FoodRepository foodRepository) {
        this.mealEntryRepository = mealEntryRepository;
        this.foodRepository = foodRepository;
    }

    @Override
    public void deleteMealEntry(UUID mealEntryId) {
        // Find the meal entry by ID
        MealEntry mealEntry = mealEntryRepository.findById(mealEntryId)
                .orElseThrow(() -> new IllegalArgumentException("Meal entry not found with ID: " + mealEntryId));

        // Delete the meal entry
        mealEntryRepository.delete(mealEntry);
    }

    @Override
    public MealEntryDto updateMealEntry(UUID mealEntryId, UUID foodId, String servingUnit, Double numberOfServings) {
        // Find the meal entry by ID
        MealEntry mealEntry = mealEntryRepository.findById(mealEntryId)
                .orElseThrow(() -> new IllegalArgumentException("Meal entry not found with ID: " + mealEntryId));

        // Find food by ID
        Food food = foodRepository.findById(foodId)
                .orElseThrow(() -> new IllegalArgumentException("Food not found with ID: " + foodId));

        // Update meal entry
        mealEntry.setFood(food);
        mealEntry.setServingUnit(ServingUnit.valueOf(servingUnit));
//        mealEntry.setNumberOfServings(numberOfServings);

        mealEntryRepository.save(mealEntry);

        return new MealEntryDto(mealEntryId, foodId, servingUnit, numberOfServings);
    }
}
