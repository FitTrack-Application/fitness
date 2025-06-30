package com.hcmus.foodservice.event.command;

import com.hcmus.foodservice.dto.FoodDto;
import com.hcmus.foodservice.dto.request.FoodRequest;
import com.hcmus.foodservice.dto.response.ApiResponse;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.stereotype.Service;


import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class FoodCommandServiceImpl implements FoodCommandService {

    private final FoodCommandHandler foodCommandHandler;

    @Transactional
    @Override
    public ApiResponse<FoodDto> createFood(FoodRequest foodDto, UUID userId) {
        CreateFoodCommand command = CreateFoodCommand.builder()
                .name(foodDto.getName())
                .calories(foodDto.getCalories())
                .protein(foodDto.getProtein())
                .carbs(foodDto.getCarbs())
                .fat(foodDto.getFat())
                .imageUrl(foodDto.getImageUrl())
                .userId(userId)
                .build();

        FoodDto result = foodCommandHandler.handleCreate(command);

        return ApiResponse.<FoodDto>builder()
                .status(200)
                .data(result)
                .generalMessage("Successfully created food!")
                .build();
    }

    @Transactional
    @Override
    public ApiResponse<?> deleteFoodByIdAndUserId(UUID foodId, UUID userId) {
        DeleteFoodCommand command = DeleteFoodCommand.builder()
                .foodId(foodId)
                .userId(userId)
                .build();

        foodCommandHandler.handleDelete(command);

        return ApiResponse.builder()
                .status(200)
                .generalMessage("Successfully deleted food!")
                .build();
    }

    @Transactional
    @Override
    public ApiResponse<FoodDto> updateFoodByIdAndUserId(UUID foodId, FoodRequest foodRequest, UUID userId) {
        UpdateFoodCommand command = UpdateFoodCommand.builder()
                .foodId(foodId)
                .name(foodRequest.getName())
                .calories(foodRequest.getCalories())
                .protein(foodRequest.getProtein())
                .carbs(foodRequest.getCarbs())
                .fat(foodRequest.getFat())
                .imageUrl(foodRequest.getImageUrl())
                .userId(userId)
                .build();

        FoodDto result = foodCommandHandler.handleUpdate(command);

        return ApiResponse.<FoodDto>builder()
                .status(200)
                .data(result)
                .generalMessage("Successfully updated food!")
                .build();
    }
}

