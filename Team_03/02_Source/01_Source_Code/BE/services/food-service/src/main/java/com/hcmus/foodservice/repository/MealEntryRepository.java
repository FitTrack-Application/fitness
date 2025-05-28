package com.hcmus.foodservice.repository;

import com.hcmus.foodservice.model.MealEntry;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.domain.Pageable;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.UUID;

public interface MealEntryRepository extends JpaRepository<MealEntry, UUID> {
    @Query("SELECT COUNT(DISTINCT me.food.foodId) FROM MealEntry me")
    Integer countDistinctFoodUsed();

    @Query("SELECT DISTINCT me.food.foodId FROM MealEntry me")
    List<UUID> findDistinctFoodIdsUsed();

    @Query("SELECT me.food.foodId FROM MealEntry me GROUP BY me.food.foodId ORDER BY COUNT(me.food.foodId) DESC")
    List<UUID> findTopMostUsedFoodIds(Pageable pageable);

    Integer countByFood_FoodId(UUID foodId);

    @Query("""
        SELECT SUM(f.caloriesPer100g * (su.conversionToGrams * me.numberOfServings) / 100)
        FROM MealEntry me
        JOIN me.food f
        JOIN me.servingUnit su
        JOIN me.mealLog ml
        WHERE ml.userId = :userId
    """)
    Double getTotalCaloriesConsumedByUserId(@Param("userId") UUID userId);

}
