package com.hcmus.foodservice.repository;

import com.hcmus.foodservice.model.*;
import com.hcmus.foodservice.model.type.MealType;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.data.domain.PageRequest;

import java.util.Date;
import java.util.List;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;

@DataJpaTest
class MealEntryRepositoryTests {

    @Autowired
    private MealEntryRepository mealEntryRepository;

    @Autowired
    private FoodRepository foodRepository;

    @Autowired
    private ServingUnitRepository servingUnitRepository;

    @Autowired
    private MealLogRepository mealLogRepository;

    private Food createFood(String name) {
        Food food = new Food();
        food.setFoodName(name);
        food.setCaloriesPer100g(100);
        food.setProteinPer100g(10.0);
        food.setCarbsPer100g(20.0);
        food.setFatPer100g(5.0);
        return foodRepository.save(food);
    }

    private ServingUnit createServingUnit(String name, String symbol) {
        ServingUnit unit = new ServingUnit();
        unit.setUnitName(name);
        unit.setUnitSymbol(symbol);
        unit.setConversionToGrams(100.0);
        return servingUnitRepository.save(unit);
    }

    private MealLog createMealLog(UUID userId) {
        MealLog log = new MealLog();
        log.setDate(new Date());
        log.setMealType(MealType.LUNCH);
        log.setUserId(userId);
        return mealLogRepository.save(log);
    }

    private MealEntry createMealEntry(MealLog log, Food food, ServingUnit unit, double servings) {
        MealEntry entry = new MealEntry();
        entry.setMealLog(log);
        entry.setFood(food);
        entry.setServingUnit(unit);
        entry.setNumberOfServings(servings);
        return mealEntryRepository.save(entry);
    }

    @Test
    void MealEntryRepository_countDistinctFoodUsed_ReturnsCorrectCount() {
        Food food1 = createFood("Apple");
        Food food2 = createFood("Banana");

        ServingUnit unit = createServingUnit("Gram", "g");
        MealLog log = createMealLog(UUID.randomUUID());

        createMealEntry(log, food1, unit, 1.0);
        createMealEntry(log, food2, unit, 1.0);
        createMealEntry(log, food1, unit, 1.0);

        Integer count = mealEntryRepository.countDistinctFoodUsed();
        assertThat(count).isEqualTo(2);
    }

    @Test
    void MealEntryRepository_findTopMostUsedFoodIds_ReturnsTopFoodByUsage() {
        Food food1 = createFood("Apple");
        Food food2 = createFood("Banana");

        ServingUnit unit = createServingUnit("Gram", "g");
        MealLog log = createMealLog(UUID.randomUUID());

        createMealEntry(log, food1, unit, 1.0);
        createMealEntry(log, food1, unit, 1.0);
        createMealEntry(log, food2, unit, 1.0);

        List<UUID> topFoods = mealEntryRepository.findTopMostUsedFoodIds(PageRequest.of(0, 1));

        assertThat(topFoods).hasSize(1);
        assertThat(topFoods.get(0)).isEqualTo(food1.getFoodId());
    }

    @Test
    void MealEntryRepository_countByFood_FoodId_ReturnsCorrectCount() {
        Food food = createFood("Egg");
        ServingUnit unit = createServingUnit("Gram", "g");
        MealLog log = createMealLog(UUID.randomUUID());

        createMealEntry(log, food, unit, 1.0);
        createMealEntry(log, food, unit, 2.0);

        Integer count = mealEntryRepository.countByFood_FoodId(food.getFoodId());
        assertThat(count).isEqualTo(2);
    }

}
