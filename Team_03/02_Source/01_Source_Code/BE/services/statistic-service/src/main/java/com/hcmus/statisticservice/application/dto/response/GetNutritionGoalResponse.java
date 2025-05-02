package com.hcmus.statisticservice.application.dto.response;

import lombok.*;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class GetNutritionGoalResponse {
    private Integer calories;

    private Macronutrients macronutrients;

    @Getter
    @Setter
    @AllArgsConstructor
    @NoArgsConstructor
    @Builder
    public static class Macronutrients {

        private Double protein;

        private Double fat;

        private Double carbs;
    }
}
