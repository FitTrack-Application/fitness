package com.hcmus.statisticservice.application.dto.response;

import lombok.*;

import java.util.List;

import com.hcmus.statisticservice.application.dto.TopFoodDto;


@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class FoodReportResponse {
    private Integer totalFood;

    private Integer totalMeal;

    private Integer usedCustomFood;

    private Integer usedAvailableFood;

    private List<TopFoodDto> topFoods;
}
