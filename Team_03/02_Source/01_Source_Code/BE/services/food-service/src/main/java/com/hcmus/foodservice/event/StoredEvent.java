package com.hcmus.foodservice.event;

import jakarta.persistence.*;
import lombok.*;
import java.time.Instant;
import java.util.UUID;

@Entity
@Table(name = "event_store")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class StoredEvent {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private UUID id;

    private String aggregateId;
    private String type;

    @Lob
    private String payload;

    private Instant occurredAt;
}
