package com.hcmus.statisticservice.repository;

import com.hcmus.statisticservice.model.WeightGoal;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface WeightGoalRepository extends JpaRepository<WeightGoal, UUID> {
    WeightGoal findByUserId(UUID userId);
}