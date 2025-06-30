package com.hcmus.foodservice.event.events;

import java.time.Instant;
import java.util.UUID;

import com.hcmus.foodservice.event.DomainEvent;

public class FoodDeletedEvent implements DomainEvent {
    private final UUID foodId;
    private final String name;
    private final Instant occurredAt;

    public FoodDeletedEvent(UUID foodId, String name) {
        this.foodId = foodId;
        this.name = name;
        this.occurredAt = Instant.now();
    }

    public UUID getFoodId() { return foodId; }
    public String getName() { return name; }

    @Override
    public String getType() {
        return "FoodDeleted";
    }

    @Override
    public Instant getOccurredAt() {
        return occurredAt;
    }
}
