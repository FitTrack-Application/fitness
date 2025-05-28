package com.hcmus.foodservice.dto.response;

import lombok.*;

import java.util.List;

import com.hcmus.foodservice.dto.TopFoodDto;


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
