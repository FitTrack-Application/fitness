package com.hcmus.fitservice.controller;

import com.hcmus.fitservice.dto.ApiResponse;
import com.hcmus.fitservice.dto.FoodDto;
import com.hcmus.fitservice.service.FoodService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/foods")
public class FoodController {
    private final FoodService foodService;

    @Autowired
    public FoodController(FoodService foodService) {
        this.foodService = foodService;
    }

    @GetMapping
    public ApiResponse<List<FoodDto>> getAllFoods() {
        List<FoodDto> foods = foodService.getAllFoods();

        return ApiResponse.<List<FoodDto>>builder()
                .status(200)
                .generalMessage("Sucessfully retrieved all foods")
                .data(foods)
                .build();
    }

    @GetMapping("/{foodId}")
    public ApiResponse<FoodDto> getFoodById(@PathVariable String foodId) {
        FoodDto food = foodService.getFoodById(UUID.fromString(foodId));

        if (food == null) {
            return ApiResponse.<FoodDto>builder()
                    .status(404)
                    .generalMessage("Food not found with ID: " + foodId)
                    .build();
        }

        return ApiResponse.<FoodDto>builder()
                .status(200)
                .generalMessage("Sucessfully retrieved food with ID: " + foodId)
                .data(food)
                .build();
    }
}
