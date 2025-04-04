package com.hcmus.fitservice.controller;


import com.hcmus.fitservice.dto.FoodDto;
import com.hcmus.fitservice.model.Food;
import com.hcmus.fitservice.service.FoodService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/foods")
public class FoodController {
    private final FoodService foodService;

    @Autowired
    public FoodController (FoodService foodService) {
        this.foodService = foodService;
    }

    @GetMapping
    public List<FoodDto> getAllFoods() {
        return foodService.getAllFoods();
    }

    @GetMapping("/{foodId}")
    public FoodDto getFoodById(@PathVariable String foodId) {
        return foodService.getFoodById(foodId);
    }
}
