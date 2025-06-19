package com.hcmus.exerciseservice.dto.request;

import lombok.*;

import java.util.UUID;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
public class ExerciseLogEntryRequest {

    private UUID exerciseId;

    private Integer duration;
}
