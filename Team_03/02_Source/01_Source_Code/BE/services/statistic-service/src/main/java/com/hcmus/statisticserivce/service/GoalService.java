package com.hcmus.statisticserivce.service;

import com.hcmus.statisticserivce.dto.GoalDto;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

public interface GoalService {
    List<GoalDto> getAllGoals();

    GoalDto getGoalById(UUID id);

    List<GoalDto> getGoalsByUserId(UUID userId);

    List<GoalDto> getGoalsByUserIdAndType(UUID userId, String goalType);

    List<GoalDto> getGoalsByUserIdAndDeadlineBefore(UUID userId, LocalDate date);

    List<GoalDto> getGoalsByUserIdAndDeadlineAfter(UUID userId, LocalDate date);

    List<GoalDto> getGoalsByUserIdAndAchievedStatus(UUID userId, Boolean achievedStatus);

    GoalDto createGoal(GoalDto goalDto);

    GoalDto updateGoal(UUID id, GoalDto goalDto);

    GoalDto updateGoalProgress(UUID id, Double currentValue);

    void deleteGoal(UUID id);
}