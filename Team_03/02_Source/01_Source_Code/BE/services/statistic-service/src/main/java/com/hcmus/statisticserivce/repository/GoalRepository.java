package com.hcmus.statisticserivce.repository;

import com.hcmus.statisticserivce.model.Goal;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@Repository
public interface GoalRepository extends JpaRepository<Goal, UUID> {
    List<Goal> findByUserId(UUID userId);

    List<Goal> findByUserIdAndGoalType(UUID userId, String goalType);

    List<Goal> findByUserIdAndDeadlineBefore(UUID userId, LocalDate date);

    List<Goal> findByUserIdAndDeadlineAfter(UUID userId, LocalDate date);

    List<Goal> findByUserIdAndAchievedStatus(UUID userId, Boolean achievedStatus);
}