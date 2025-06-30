package com.hcmus.foodservice.event;

import java.time.Instant;

public interface DomainEvent {
    String getType();        
    Instant getOccurredAt(); 
}
