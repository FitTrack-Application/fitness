package com.hcmus.foodservice.event.events;

import com.hcmus.foodservice.event.DomainEvent;

import lombok.AllArgsConstructor;
import lombok.Getter;

import java.time.Instant;
import java.util.UUID;

@Getter
@AllArgsConstructor
public class FoodCreatedEvent implements DomainEvent {

    private final UUID foodId;
    private final String name;
    private final Integer calories;
    private final Double protein;
    private final Double carbs;
    private final Double fat;
    private final String imageUrl;
    private final UUID userId;
    private final Instant occurredAt;

    public FoodCreatedEvent(
            UUID foodId,
            String name,
            Integer calories,
            Double protein,
            Double carbs,
            Double fat,
            String imageUrl,
            UUID userId
    ) {
        this.foodId = foodId;
        this.name = name;
        this.calories = calories;
        this.protein = protein;
        this.carbs = carbs;
        this.fat = fat;
        this.imageUrl = imageUrl;
        this.userId = userId;
        this.occurredAt = Instant.now();
    }

    @Override
    public String getType() {
        return "FoodCreated";
    }
}
