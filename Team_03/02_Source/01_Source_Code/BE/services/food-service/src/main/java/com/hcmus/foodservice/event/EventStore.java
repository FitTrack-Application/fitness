package com.hcmus.foodservice.event;

import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
@RequiredArgsConstructor
public class EventStore {

    private final EventStoreRepository repository;
    private final ObjectMapper objectMapper;

    public void save(String aggregateId, DomainEvent event) {
        try {
            String json = objectMapper.writeValueAsString(event);
            StoredEvent storedEvent = StoredEvent.builder()
                    .aggregateId(aggregateId)
                    .type(event.getType())
                    .payload(json)
                    .occurredAt(event.getOccurredAt())
                    .build();

            repository.save(storedEvent);
        } catch (Exception e) {
            throw new RuntimeException("Failed to save event", e);
        }
    }

    public <T extends DomainEvent> List<T> getEvents(String aggregateId, Class<T> eventType) {
        return repository.findByAggregateId(aggregateId).stream()
                .map(e -> {
                    try {
                        return objectMapper.readValue(e.getPayload(), eventType);
                    } catch (Exception ex) {
                        throw new RuntimeException("Failed to deserialize event", ex);
                    }
                })
                .toList();
    }
}
