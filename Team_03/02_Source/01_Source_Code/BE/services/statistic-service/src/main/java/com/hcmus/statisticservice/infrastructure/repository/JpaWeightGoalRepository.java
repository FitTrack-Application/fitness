package com.hcmus.statisticservice.infrastructure.repository;

import com.hcmus.statisticservice.domain.model.WeightGoal;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface JpaWeightGoalRepository extends JpaRepository<WeightGoal, UUID> {
    List<WeightGoal> findByUserId(UUID userId);

    Optional<WeightGoal> findTopByUserIdOrderByStartingDateDesc(UUID userId);

    boolean existsByUserId(UUID userId);
}