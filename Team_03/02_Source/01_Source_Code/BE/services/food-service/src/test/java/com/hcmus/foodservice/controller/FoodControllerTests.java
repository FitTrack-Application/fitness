package com.hcmus.foodservice.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.hcmus.foodservice.dto.FoodDto;
import com.hcmus.foodservice.dto.request.FoodRequest;
import com.hcmus.foodservice.dto.response.ApiResponse;
import com.hcmus.foodservice.dto.response.FoodMacrosDetailsResponse;
import com.hcmus.foodservice.service.FoodService;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Primary;
import org.springframework.data.domain.PageRequest;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.RequestPostProcessor;

import java.util.List;
import java.util.UUID;

import static org.mockito.ArgumentMatchers.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(FoodController.class)
class FoodControllerTests {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private FoodService foodService;

    @Autowired
    private ObjectMapper objectMapper;

    @TestConfiguration
    static class TestSecurityConfig {
        @Bean
        @Primary
        SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
            http
                    .csrf().disable()
                    .authorizeHttpRequests(auth -> auth.anyRequest().permitAll());
            return http.build();
        }
    }

    private RequestPostProcessor uuidAuth() {
        return request -> {
            String validUserId = "123e4567-e89b-12d3-a456-426614174000";
            String roles = "USER";
            request.addHeader("X-User-Id", validUserId);
            request.addHeader("X-User-Roles", roles);
            return request;
        };
    }


    private FoodRequest createValidFoodRequest() {
        FoodRequest request = new FoodRequest();
        request.setName("Chicken Breast");
        request.setCalories(165);
        request.setProtein(31.0);
        request.setCarbs(0.0);
        request.setFat(3.6);
        request.setImageUrl("https://example.com/image.jpg");
        return request;
    }

    @Test
    void getFoodById_shouldReturnFoodDto() throws Exception {
        UUID foodId = UUID.randomUUID();
        FoodDto foodDto = new FoodDto();
        foodDto.setId(foodId);

        ApiResponse<FoodDto> response = ApiResponse.<FoodDto>builder()
                .status(200)
                .generalMessage("Success")
                .data(foodDto)
                .build();

        Mockito.when(foodService.getFoodById(foodId)).thenReturn(response);

        mockMvc.perform(get("/api/foods/{foodId}", foodId).with(uuidAuth()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.id").value(foodId.toString()))
                .andExpect(jsonPath("$.status").value(200))
                .andExpect(jsonPath("$.generalMessage").value("Success"));
    }

    @Test
    void getFoodMacrosDetails_shouldReturnMacrosDetails() throws Exception {
        UUID foodId = UUID.randomUUID();
        UUID servingUnitId = UUID.randomUUID();
        double servings = 2;

        FoodMacrosDetailsResponse details = new FoodMacrosDetailsResponse();

        ApiResponse<FoodMacrosDetailsResponse> response = ApiResponse.<FoodMacrosDetailsResponse>builder()
                .status(200)
                .generalMessage("Success")
                .data(details)
                .build();

        Mockito.when(foodService.getFoodMacrosDetailsById(eq(foodId), eq(servingUnitId), eq(servings)))
                .thenReturn(response);

        mockMvc.perform(get("/api/foods/{foodId}/macros-details", foodId)
                        .param("servingUnitId", servingUnitId.toString())
                        .param("numberOfServings", String.valueOf(servings))
                        .with(uuidAuth()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status").value(200))
                .andExpect(jsonPath("$.generalMessage").value("Success"));
    }

    @Test
    void getFoods_shouldReturnListOfFoods() throws Exception {
        FoodDto food = new FoodDto();

        ApiResponse<List<FoodDto>> response = ApiResponse.<List<FoodDto>>builder()
                .status(200)
                .generalMessage("Success")
                .data(List.of(food))
                .build();

        Mockito.when(foodService.getSystemFoods(any(PageRequest.class)))
                .thenReturn(response);

        mockMvc.perform(get("/api/foods").param("page", "1").param("size", "10").with(uuidAuth()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data").isArray())
                .andExpect(jsonPath("$.status").value(200))
                .andExpect(jsonPath("$.generalMessage").value("Success"));
    }

    @Test
    void getFoodFromBarcode_shouldReturnFood() throws Exception {
        String barcode = "123456789";
        FoodDto food = new FoodDto();

        ApiResponse<FoodDto> response = ApiResponse.<FoodDto>builder()
                .status(200)
                .generalMessage("Success")
                .data(food)
                .build();

        Mockito.when(foodService.scanFood(barcode)).thenReturn(response);

        mockMvc.perform(get("/api/foods/scan").param("barcode", barcode).with(uuidAuth()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status").value(200))
                .andExpect(jsonPath("$.generalMessage").value("Success"));
    }

}
