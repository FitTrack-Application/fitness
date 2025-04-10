package com.hcmus.fitservice.repository;

import com.hcmus.fitservice.model.MealLog;
import com.hcmus.fitservice.model.MealType;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Date;
import java.util.UUID;

public interface MealLogRepository extends JpaRepository<MealLog, UUID> {
    MealLog findByUserIdAndDateAndMealType(UUID userId, Date date, MealType mealType);

    MealLog findByUserIdAndDate(UUID userId, Date date);
}
