package com.hcmus.statisticservice.infrastructure.repository;

import com.hcmus.statisticservice.domain.model.NutritionGoal;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface JpaNutritionGoalRepository extends JpaRepository<NutritionGoal, UUID> {
    Optional<NutritionGoal> findByUserId(UUID userId);

    boolean existsByUserId(UUID userId);
}