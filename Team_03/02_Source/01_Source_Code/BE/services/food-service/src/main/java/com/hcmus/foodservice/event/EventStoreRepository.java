package com.hcmus.foodservice.event;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface EventStoreRepository extends JpaRepository<StoredEvent, UUID> {
    List<StoredEvent> findByAggregateId(String aggregateId);
}
