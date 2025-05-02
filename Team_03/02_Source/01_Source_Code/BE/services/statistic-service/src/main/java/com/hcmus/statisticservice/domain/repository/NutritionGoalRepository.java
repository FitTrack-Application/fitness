package com.hcmus.statisticservice.domain.repository;

import com.hcmus.statisticservice.domain.model.NutritionGoal;

import java.util.Optional;
import java.util.UUID;

public interface NutritionGoalRepository {
    NutritionGoal save(NutritionGoal nutritionGoal);

    Optional<NutritionGoal> findByUserId(UUID userId);

    void deleteById(UUID id);
}