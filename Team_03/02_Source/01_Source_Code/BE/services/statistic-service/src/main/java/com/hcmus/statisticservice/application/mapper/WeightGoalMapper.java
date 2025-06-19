package com.hcmus.statisticservice.application.mapper;

import com.hcmus.statisticservice.application.dto.request.CreateWeightGoalRequest;
import com.hcmus.statisticservice.application.dto.response.WeightGoalResponse;
import com.hcmus.statisticservice.domain.model.WeightGoal;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.time.ZoneId;
import java.util.Date;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Component
public class WeightGoalMapper {

    public WeightGoal toEntity(CreateWeightGoalRequest request, UUID userId) {
        LocalDate startDate = request.getStartDate() != null ? request.getStartDate() : LocalDate.now();

        return WeightGoal.builder()
                .userId(userId)
                .startingWeight(request.getStartWeight())
                .goalWeight(request.getTargetWeight())
                .startingDate(Date.from(startDate.atStartOfDay(ZoneId.systemDefault()).toInstant()))
                .weeklyGoal(calculateWeeklyGoal(request.getStartWeight(), request.getTargetWeight(),
                        request.getStartDate(), request.getTargetDate()))
                .build();
    }

    public WeightGoalResponse toResponse(WeightGoal weightGoal, Double currentWeight, Double progressPercentage,
                                         Long estimatedDaysToTarget) {
        return WeightGoalResponse.builder()
                .id(weightGoal.getWeightGoalId())
                .startWeight(weightGoal.getStartingWeight())
                .targetWeight(weightGoal.getGoalWeight())
                .currentWeight(currentWeight)
                .startDate(toLocalDate(weightGoal.getStartingDate()))
                .targetDate(calculateTargetDate(weightGoal.getStartingDate(), weightGoal.getWeeklyGoal(),
                        weightGoal.getStartingWeight(), weightGoal.getGoalWeight()))
                .status("ACTIVE") // Thiết lập mặc định, có thể cập nhật sau
                .progressPercentage(progressPercentage)
                .estimatedDaysToTarget(estimatedDaysToTarget)
                .build();
    }

    public List<WeightGoalResponse> toResponseList(List<WeightGoal> weightGoals, Double currentWeight,
                                                   Double progressPercentage, Long estimatedDaysToTarget) {
        return weightGoals.stream()
                .map(weightGoal -> toResponse(weightGoal, currentWeight, progressPercentage, estimatedDaysToTarget))
                .collect(Collectors.toList());
    }

    private LocalDate toLocalDate(Date date) {
        return date.toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
    }

    private Double calculateWeeklyGoal(Double startWeight, Double targetWeight, LocalDate startDate,
                                       LocalDate targetDate) {
        long weeks = startDate.until(targetDate).getDays() / 7;
        if (weeks <= 0)
            weeks = 1; // Tránh chia cho 0
        return Math.abs(targetWeight - startWeight) / weeks;
    }

    private LocalDate calculateTargetDate(Date startingDate, Double weeklyGoal, Double startingWeight,
                                          Double goalWeight) {
        LocalDate startDate = toLocalDate(startingDate);
        double totalChange = Math.abs(goalWeight - startingWeight);
        int weeks = (int) Math.ceil(totalChange / weeklyGoal);
        return startDate.plusWeeks(weeks);
    }
}