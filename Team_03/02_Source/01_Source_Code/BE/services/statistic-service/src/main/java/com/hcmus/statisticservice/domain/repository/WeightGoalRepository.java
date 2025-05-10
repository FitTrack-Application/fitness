package com.hcmus.statisticservice.domain.repository;

import com.hcmus.statisticservice.domain.model.WeightGoal;

import java.util.Optional;
import java.util.UUID;

public interface WeightGoalRepository {
    WeightGoal save(WeightGoal weightGoal);

    boolean existsByUserId(UUID userId);

    Optional<WeightGoal> findByUserId(UUID userId);

    void deleteById(UUID id);
}