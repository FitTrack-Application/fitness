package com.hcmus.statisticservice.domain.service;

import com.hcmus.statisticservice.domain.model.WeightGoal;
import com.hcmus.statisticservice.domain.model.WeightLog;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.ZoneId;
import java.time.temporal.ChronoUnit;
import java.util.Date;
import java.util.List;

@Service
public class WeightCalculationService {

    /**
     * Calculate the progress percentage of weight goal achievement
     *
     * @param weightGoal    The weight goal
     * @param currentWeight Current weight
     * @return Progress percentage
     */
    public double calculateProgressPercentage(WeightGoal weightGoal, double currentWeight) {
        double totalWeightChange = weightGoal.getGoalWeight() -
                weightGoal.getStartingWeight();
        double actualWeightChange = currentWeight - weightGoal.getStartingWeight();

        if (totalWeightChange == 0) {
            return 100.0; // Goal already achieved
        }

        // For weight gain goals
        if (totalWeightChange > 0) {
            if (actualWeightChange >= totalWeightChange) {
                return 100.0;
            } else if (actualWeightChange <= 0) {
                return 0.0;
            } else {
                return (actualWeightChange / totalWeightChange) * 100.0;
            }
        }
        // For weight loss goals
        else {
            if (actualWeightChange <= totalWeightChange) {
                return 100.0;
            } else if (actualWeightChange >= 0) {
                return 0.0;
            } else {
                return (actualWeightChange / totalWeightChange) * 100.0;
            }
        }
    }

    /**
     * Estimate the time remaining to achieve the goal
     *
     * @param weightGoal The weight goal
     * @param weightLogs List of weight logs
     * @return Estimated days to reach the target
     */
    public long estimateDaysToTarget(WeightGoal weightGoal, List<WeightLog> weightLogs) {
        if (weightLogs.isEmpty() || weightLogs.size() < 2) {
            // Calculate based on initial plan if not enough data
            LocalDate targetDate = convertToLocalDate(weightGoal.getStartingDate()).plusDays(30); // Assume 30 days
            return ChronoUnit.DAYS.between(LocalDate.now(), targetDate);
        }

        // Sort by record date
        weightLogs.sort((a, b) -> a.getDate().compareTo(b.getDate()));

        // Get latest weight
        double latestWeight = weightLogs.get(weightLogs.size() - 1).getWeight();

        // Calculate average weight change rate (kg/day)
        double firstWeight = weightLogs.get(0).getWeight();
        long daysBetween = ChronoUnit.DAYS.between(
                convertToLocalDate(weightLogs.get(0).getDate()),
                convertToLocalDate(weightLogs.get(weightLogs.size() - 1).getDate()));

        if (daysBetween == 0) {
            LocalDate targetDate = convertToLocalDate(weightGoal.getStartingDate()).plusDays(30);
            return ChronoUnit.DAYS.between(LocalDate.now(), targetDate);
        }

        double weightChangeRate = (latestWeight - firstWeight) / daysBetween;

        // If weight change rate is 0 or in opposite direction of the goal
        if (weightChangeRate == 0 ||
                (weightGoal.getGoalWeight() > weightGoal.getStartingWeight() &&
                        weightChangeRate < 0)
                ||
                (weightGoal.getGoalWeight() < weightGoal.getStartingWeight() &&
                        weightChangeRate > 0)) {
            LocalDate targetDate = convertToLocalDate(weightGoal.getStartingDate()).plusDays(30);
            return ChronoUnit.DAYS.between(LocalDate.now(), targetDate);
        }

        // Calculate remaining days to reach the goal
        double remainingChange = weightGoal.getGoalWeight() - latestWeight;
        long estimatedDays = (long) Math.abs(remainingChange / weightChangeRate);

        return estimatedDays;
    }

    /**
     * Check if the goal has been achieved based on current weight
     *
     * @param weightGoal    The weight goal
     * @param currentWeight Current weight
     * @return true if the goal has been achieved
     */
    public boolean isGoalAchieved(WeightGoal weightGoal, double currentWeight) {
        // For weight gain goals
        if (weightGoal.getGoalWeight() > weightGoal.getStartingWeight()) {
            return currentWeight >= weightGoal.getGoalWeight();
        }
        // For weight loss goals
        else if (weightGoal.getGoalWeight() < weightGoal.getStartingWeight()) {
            return currentWeight <= weightGoal.getGoalWeight();
        }
        // For weight maintenance goals
        else {
            return Math.abs(currentWeight - weightGoal.getGoalWeight()) < 0.5; // Allow 0.5kg error margin
        }
    }

    private LocalDate convertToLocalDate(Date date) {
        return date.toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
    }
}