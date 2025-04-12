package com.hcmus.statisticserivce.service;

import com.hcmus.statisticserivce.exception.ResourceNotFoundException;
import com.hcmus.statisticserivce.repository.GoalRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class GoalServiceImpl implements GoalService {

    private final GoalRepository goalRepository;

    @Override
    public List<GoalDto> getAllGoals() {
        return goalRepository.findAll().stream()
                .map(this::mapToDto)
                .collect(Collectors.toList());
    }

    @Override
    public GoalDto getGoalById(UUID id) {
        Goal goal = goalRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Goal", "id", id));
        return mapToDto(goal);
    }

    @Override
    public List<GoalDto> getGoalsByUserId(UUID userId) {
        return goalRepository.findByUserId(userId).stream()
                .map(this::mapToDto)
                .collect(Collectors.toList());
    }

    @Override
    public List<GoalDto> getGoalsByUserIdAndType(UUID userId, String goalType) {
        return goalRepository.findByUserIdAndGoalType(userId, goalType).stream()
                .map(this::mapToDto)
                .collect(Collectors.toList());
    }

    @Override
    public List<GoalDto> getGoalsByUserIdAndDeadlineBefore(UUID userId, LocalDate date) {
        return goalRepository.findByUserIdAndDeadlineBefore(userId, date).stream()
                .map(this::mapToDto)
                .collect(Collectors.toList());
    }

    @Override
    public List<GoalDto> getGoalsByUserIdAndDeadlineAfter(UUID userId, LocalDate date) {
        return goalRepository.findByUserIdAndDeadlineAfter(userId, date).stream()
                .map(this::mapToDto)
                .collect(Collectors.toList());
    }

    @Override
    public List<GoalDto> getGoalsByUserIdAndAchievedStatus(UUID userId, Boolean achievedStatus) {
        return goalRepository.findByUserIdAndAchievedStatus(userId, achievedStatus).stream()
                .map(this::mapToDto)
                .collect(Collectors.toList());
    }

    @Override
    public GoalDto createGoal(GoalDto goalDto) {
        Goal goal = mapToEntity(goalDto);

        // Calculate initial progress if both values are provided
        if (goal.getCurrentValue() != null && goal.getTargetValue() != null && goal.getTargetValue() > 0) {
            double progress = (goal.getCurrentValue() / goal.getTargetValue()) * 100;
            goal.setProgress(progress);

            // Check if goal is achieved
            if (progress >= 100) {
                goal.setAchievedStatus(true);
            }
        } else {
            goal.setProgress(0.0);
        }

        Goal savedGoal = goalRepository.save(goal);
        return mapToDto(savedGoal);
    }

    @Override
    public GoalDto updateGoal(UUID id, GoalDto goalDto) {
        Goal goal = goalRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Goal", "id", id));

        goal.setUserId(goalDto.getUserId());
        goal.setGoalType(goalDto.getGoalType());
        goal.setTargetValue(goalDto.getTargetValue());
        goal.setCurrentValue(goalDto.getCurrentValue());
        goal.setDeadline(goalDto.getDeadline());

        // Recalculate progress
        if (goal.getCurrentValue() != null && goal.getTargetValue() != null && goal.getTargetValue() > 0) {
            double progress = (goal.getCurrentValue() / goal.getTargetValue()) * 100;
            goal.setProgress(progress);

            // Update achieved status
            goal.setAchievedStatus(progress >= 100);
        }

        Goal updatedGoal = goalRepository.save(goal);
        return mapToDto(updatedGoal);
    }

    @Override
    public GoalDto updateGoalProgress(UUID id, Double currentValue) {
        Goal goal = goalRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Goal", "id", id));

        goal.setCurrentValue(currentValue);

        // Recalculate progress
        if (goal.getTargetValue() != null && goal.getTargetValue() > 0) {
            double progress = (currentValue / goal.getTargetValue()) * 100;
            goal.setProgress(progress);

            // Update achieved status
            goal.setAchievedStatus(progress >= 100);
        }

        Goal updatedGoal = goalRepository.save(goal);
        return mapToDto(updatedGoal);
    }

    @Override
    public void deleteGoal(UUID id) {
        Goal goal = goalRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Goal", "id", id));
        goalRepository.delete(goal);
    }

    private GoalDto mapToDto(Goal goal) {
        return GoalDto.builder()
                .goalId(goal.getGoalId())
                .userId(goal.getUserId())
                .goalType(goal.getGoalType())
                .targetValue(goal.getTargetValue())
                .currentValue(goal.getCurrentValue())
                .progress(goal.getProgress())
                .deadline(goal.getDeadline())
                .achievedStatus(goal.getAchievedStatus())
                .build();
    }

    private Goal mapToEntity(GoalDto goalDto) {
        Goal goal = new Goal();
        goal.setUserId(goalDto.getUserId());
        goal.setGoalType(goalDto.getGoalType());
        goal.setTargetValue(goalDto.getTargetValue());
        goal.setCurrentValue(goalDto.getCurrentValue());
        goal.setProgress(goalDto.getProgress());
        goal.setDeadline(goalDto.getDeadline());
        goal.setAchievedStatus(goalDto.getAchievedStatus() != null ? goalDto.getAchievedStatus() : false);
        return goal;
    }
}