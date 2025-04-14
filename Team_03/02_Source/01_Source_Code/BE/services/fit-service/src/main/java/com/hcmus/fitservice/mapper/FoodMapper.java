package com.hcmus.fitservice.mapper;

import com.hcmus.fitservice.dto.FoodDto;
import com.hcmus.fitservice.model.Food;
import org.mapstruct.*;
import org.mapstruct.factory.Mappers;

@Mapper(unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface FoodMapper {

    FoodMapper INSTANCE = Mappers.getMapper(FoodMapper.class);

    @Mapping(target = "id", source = "foodId")
    @Mapping(target = "name", source = "foodName")
    @Mapping(target = "calories", source = "caloriesPer100g")
    @Mapping(target = "protein", source = "proteinPer100g")
    @Mapping(target = "carbs", source = "carbsPer100g")
    @Mapping(target = "fat", source = "fatPer100g")
    FoodDto convertToFoodDto(Food user);
}