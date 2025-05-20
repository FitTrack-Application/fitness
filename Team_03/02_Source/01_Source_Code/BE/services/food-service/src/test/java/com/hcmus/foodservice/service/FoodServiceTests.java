package com.hcmus.foodservice.service;

import com.hcmus.foodservice.dto.FoodDto;
import com.hcmus.foodservice.dto.request.FoodRequest;
import com.hcmus.foodservice.dto.response.ApiResponse;
import com.hcmus.foodservice.dto.response.FoodMacrosDetailsResponse;
import com.hcmus.foodservice.mapper.FoodMapper;
import com.hcmus.foodservice.model.Food;
import com.hcmus.foodservice.model.ServingUnit;
import com.hcmus.foodservice.repository.FoodRepository;
import com.hcmus.foodservice.repository.ServingUnitRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.*;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.*;

import java.util.*;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;


public class FoodServiceTests {

    @Mock
    private FoodRepository foodRepository;

    @Mock
    private ServingUnitRepository servingUnitRepository;

    @Mock
    private FoodMapper foodMapper;

    @InjectMocks
    private FoodServiceImpl foodService;

    @BeforeEach
    public void setup() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    public void FoodService_getFoodById_ReturnsFoodDto() {
        UUID foodId = UUID.randomUUID();
        Food food = new Food();
        FoodDto foodDto = new FoodDto();

        when(foodRepository.findById(foodId)).thenReturn(Optional.of(food));
        when(foodMapper.convertToFoodDto(food)).thenReturn(foodDto);

        ApiResponse<FoodDto> response = foodService.getFoodById(foodId);

        assertEquals(200, response.getStatus());
        assertNotNull(response.getData());
    }

    @Test
    public void FoodService_getFoodMacrosDetailsById_ReturnsDetailsResponse() {
        UUID foodId = UUID.randomUUID();
        UUID servingId = UUID.randomUUID();
        double servings = 2.0;

        Food food = new Food();
        ServingUnit servingUnit = new ServingUnit();
        FoodMacrosDetailsResponse expected = new FoodMacrosDetailsResponse();

        when(foodRepository.findById(foodId)).thenReturn(Optional.of(food));
        when(servingUnitRepository.findById(servingId)).thenReturn(Optional.of(servingUnit));
        when(foodMapper.converToFoodMacrosDetailsResponse(food, servingUnit, servings)).thenReturn(expected);

        ApiResponse<FoodMacrosDetailsResponse> response = foodService.getFoodMacrosDetailsById(foodId, servingId, servings);

        assertEquals(200, response.getStatus());
        assertEquals(expected, response.getData());
    }

    @Test
    public void FoodService_getSystemFoods_ReturnsPagedList() {
        Pageable pageable = PageRequest.of(0, 5);
        List<Food> foods = List.of(new Food(), new Food());
        Page<Food> page = new PageImpl<>(foods, pageable, 2);

        when(foodRepository.findByUserIdIsNull(pageable)).thenReturn(page);
        when(foodMapper.convertToFoodDto(any(Food.class))).thenReturn(new FoodDto());

        ApiResponse<List<FoodDto>> response = foodService.getSystemFoods(pageable);

        assertEquals(200, response.getStatus());
        assertEquals(2, response.getData().size());
    }

    @Test
    public void FoodService_searchSystemFoodsByName_ReturnsPagedList() {
        Pageable pageable = PageRequest.of(0, 10);
        Page<Food> page = new PageImpl<>(List.of(new Food()));

        when(foodRepository.findByUserIdIsNullAndFoodNameContainingIgnoreCase("rice", pageable)).thenReturn(page);
        when(foodMapper.convertToFoodDto(any(Food.class))).thenReturn(new FoodDto());

        ApiResponse<List<FoodDto>> response = foodService.searchSystemFoodsByName("rice", pageable);

        assertEquals(200, response.getStatus());
        assertEquals(1, response.getData().size());
    }

    @Test
    public void FoodService_getFoodsByUserId_ReturnsPagedList() {
        UUID userId = UUID.randomUUID();
        Pageable pageable = PageRequest.of(0, 10);
        Page<Food> page = new PageImpl<>(List.of(new Food()));

        when(foodRepository.findByUserId(userId, pageable)).thenReturn(page);
        when(foodMapper.convertToFoodDto(any(Food.class))).thenReturn(new FoodDto());

        ApiResponse<List<FoodDto>> response = foodService.getFoodsByUserId(userId, pageable);

        assertEquals(200, response.getStatus());
        assertFalse(response.getData().isEmpty());
    }

    @Test
    public void FoodService_searchFoodsByUserIdAndName_ReturnsPagedList() {
        UUID userId = UUID.randomUUID();
        Pageable pageable = PageRequest.of(0, 5);
        Page<Food> page = new PageImpl<>(List.of(new Food()));

        when(foodRepository.findByUserIdAndFoodNameContainingIgnoreCase(userId, "banana", pageable)).thenReturn(page);
        when(foodMapper.convertToFoodDto(any(Food.class))).thenReturn(new FoodDto());

        ApiResponse<List<FoodDto>> response = foodService.searchFoodsByUserIdAndName(userId, "banana", pageable);

        assertEquals(200, response.getStatus());
        assertEquals(1, response.getData().size());
    }

    @Test
    public void FoodService_createFood_ReturnsSuccess() {
        UUID userId = UUID.randomUUID();
        FoodRequest request = FoodRequest.builder()
                .name("Egg")
                .calories(100)
                .protein(8.0)
                .carbs(1.0)
                .fat(5.0)
                .imageUrl("url")
                .build();

        ApiResponse<?> response = foodService.createFood(request, userId);

        assertEquals(200, response.getStatus());
        verify(foodRepository, times(1)).save(any(Food.class));
    }

    @Test
    public void FoodService_deleteFoodByIdAndUserId_ReturnsSuccess() {
        UUID foodId = UUID.randomUUID();
        UUID userId = UUID.randomUUID();
        Food food = new Food();

        when(foodRepository.findByFoodIdAndUserId(foodId, userId)).thenReturn(food);

        ApiResponse<?> response = foodService.deleteFoodByIdAndUserId(foodId, userId);

        assertEquals(200, response.getStatus());
        verify(foodRepository).delete(food);
    }

    @Test
    public void FoodService_updateFoodByIdAndUserId_ReturnsSuccess() {
        UUID foodId = UUID.randomUUID();
        UUID userId = UUID.randomUUID();

        Food existingFood = new Food();
        existingFood.setFoodName("Old name");

        FoodRequest update = FoodRequest.builder()
                .name("New name")
                .calories(150)
                .protein(10.0)
                .carbs(15.0)
                .fat(5.0)
                .imageUrl("new-url")
                .build();

        when(foodRepository.findByFoodIdAndUserId(foodId, userId)).thenReturn(existingFood);

        ApiResponse<?> response = foodService.updateFoodByIdAndUserId(foodId, update, userId);

        assertEquals(200, response.getStatus());
        assertEquals("New name", existingFood.getFoodName());
        verify(foodRepository).save(existingFood);
    }
}
