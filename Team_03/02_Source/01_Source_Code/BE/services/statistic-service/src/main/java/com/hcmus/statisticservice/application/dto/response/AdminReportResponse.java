package com.hcmus.statisticservice.application.dto.response;

import java.util.List;

import com.hcmus.statisticservice.application.dto.CustomExerciseUsageDto;
import com.hcmus.statisticservice.application.dto.CustomFoodUsageDto;
import com.hcmus.statisticservice.application.dto.EarlyChurnByWeekDto;
import com.hcmus.statisticservice.application.dto.NewUsersByWeekDto;
import com.hcmus.statisticservice.application.dto.TopExerciseDto;
import com.hcmus.statisticservice.application.dto.TopFoodDto;

import lombok.*;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class AdminReportResponse {
    private Integer totalUsers;

    private Integer activeUsers;

    private Integer totalMeals;

    private Integer totalFoods;

    private Integer totalExercises;

    private List<NewUsersByWeekDto> newUsersByWeek;

    private List<EarlyChurnByWeekDto> earlyChurnByWeek;

    private List<CustomFoodUsageDto> customFoodUsage;

    private List<CustomExerciseUsageDto> customExerciseUsage;

    private List<TopFoodDto> topFoods;

    private List<TopExerciseDto> topExercises;
}
