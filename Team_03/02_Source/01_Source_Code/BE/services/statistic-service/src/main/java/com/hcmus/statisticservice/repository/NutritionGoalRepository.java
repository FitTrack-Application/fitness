package com.hcmus.statisticservice.repository;

import com.hcmus.statisticservice.model.NutritionGoal;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface NutritionGoalRepository extends JpaRepository<NutritionGoal, UUID> {

    Optional<NutritionGoal> findByUserId(UUID userId);
}
