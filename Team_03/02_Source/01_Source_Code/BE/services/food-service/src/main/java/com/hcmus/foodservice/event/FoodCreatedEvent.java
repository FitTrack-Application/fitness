package com.hcmus.foodservice.event;

import java.time.Instant;
import java.util.UUID;

public class FoodCreatedEvent implements DomainEvent {
    private final UUID foodId;
    private final String name;
    private final Instant occurredAt;

    public FoodCreatedEvent(UUID foodId, String name) {
        this.foodId = foodId;
        this.name = name;
        this.occurredAt = Instant.now();
    }

    public UUID getFoodId() { return foodId; }
    public String getName() { return name; }

    @Override
    public String getType() {
        return "FoodCreated";
    }

    @Override
    public Instant getOccurredAt() {
        return occurredAt;
    }
}
