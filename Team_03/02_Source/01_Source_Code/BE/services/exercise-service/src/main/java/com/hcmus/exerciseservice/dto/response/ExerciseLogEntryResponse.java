package com.hcmus.exerciseservice.dto.response;

import com.hcmus.exerciseservice.dto.ExerciseDto;
import lombok.*;

import java.util.UUID;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
public class ExerciseLogEntryResponse {

    private UUID id;

    private ExerciseDto exercise;

    private Integer duration;

    private Integer caloriesBurned;
}
