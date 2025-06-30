package com.hcmus.foodservice.event;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.hcmus.foodservice.model.Food;
import com.hcmus.foodservice.repository.FoodRepository;
import com.hcmus.foodservice.event.events.FoodCreatedEvent;
import com.hcmus.foodservice.event.events.FoodUpdatedEvent;
import com.hcmus.foodservice.event.model.StoredEvent;
import com.hcmus.foodservice.event.events.FoodDeletedEvent;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class FoodProjectionService {

    private final FoodRepository foodRepository;
    private final EventStoreRepository eventStoreRepository;
    private final ObjectMapper objectMapper;

    public void apply(FoodCreatedEvent event) {
        Food food = new Food();
        food.setFoodId(event.getFoodId());
        food.setFoodName(event.getName());
        food.setCaloriesPer100g(event.getCalories());
        food.setProteinPer100g(event.getProtein());
        food.setCarbsPer100g(event.getCarbs());
        food.setFatPer100g(event.getFat());
        food.setImageUrl(event.getImageUrl());
        food.setUserId(event.getUserId());
        foodRepository.save(food);
        log.info("Projected FoodCreatedEvent for foodId: {}", event.getFoodId());
    }

    public void apply(FoodUpdatedEvent event) {
        Food food = foodRepository.findById(event.getFoodId())
                .orElseThrow(() -> new RuntimeException("Food not found: " + event.getFoodId()));

        if (event.getName() != null) food.setFoodName(event.getName());
        if (event.getCalories() != null) food.setCaloriesPer100g(event.getCalories());
        if (event.getProtein() != null) food.setProteinPer100g(event.getProtein());
        if (event.getCarbs() != null) food.setCarbsPer100g(event.getCarbs());
        if (event.getFat() != null) food.setFatPer100g(event.getFat());
        if (event.getImageUrl() != null) food.setImageUrl(event.getImageUrl());

        foodRepository.save(food);
        log.info("Projected FoodUpdatedEvent for foodId: {}", event.getFoodId());
    }

    public void apply(FoodDeletedEvent event) {
        foodRepository.deleteById(event.getFoodId());
        log.info("Projected FoodDeletedEvent for foodId: {}", event.getFoodId());
    }

    // Dùng khi khôi phục lại Read Model từ Event Store
    public void replayAll() {
        List<StoredEvent> events = eventStoreRepository.findAll();

        for (StoredEvent stored : events) {
            try {
                switch (stored.getType()) {
                    case "FoodCreated" -> {
                        FoodCreatedEvent created = objectMapper.readValue(stored.getPayload(), FoodCreatedEvent.class);
                        apply(created);
                    }
                    case "FoodUpdated" -> {
                        FoodUpdatedEvent updated = objectMapper.readValue(stored.getPayload(), FoodUpdatedEvent.class);
                        apply(updated);
                    }
                    case "FoodDeleted" -> {
                        FoodDeletedEvent deleted = objectMapper.readValue(stored.getPayload(), FoodDeletedEvent.class);
                        apply(deleted);
                    }
                    default -> log.warn("Unknown event type: {}", stored.getType());
                }
            } catch (Exception e) {
                log.error("Failed to replay event id {}: {}", stored.getId(), e.getMessage());
            }
        }
        log.info("Completed replay of all events to rebuild read model.");
    }
} 
