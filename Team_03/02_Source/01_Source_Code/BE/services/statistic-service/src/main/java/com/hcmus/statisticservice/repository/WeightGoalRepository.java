package com.hcmus.statisticservice.repository;

import com.hcmus.statisticservice.model.WeightGoal;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface WeightGoalRepository extends JpaRepository<WeightGoal, UUID> {

    Boolean existsByUserId(UUID userId);

    Optional<WeightGoal> findByUserId(UUID userId);
}