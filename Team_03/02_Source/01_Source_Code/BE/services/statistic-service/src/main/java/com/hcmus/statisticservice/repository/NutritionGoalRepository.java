package com.hcmus.statisticservice.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.hcmus.statisticservice.model.NutritionGoal;
import java.util.UUID;

@Repository
public interface NutritionGoalRepository extends JpaRepository<NutritionGoal, UUID> {
    NutritionGoal findByUserId(UUID userId);
    
}
