package com.hcmus.exerciseservice.dto.response;

import lombok.*;

import java.util.Date;
import java.util.List;
import java.util.UUID;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
public class ExerciseLogResponse {
    private UUID id;

    private Date date;

    private List<ExerciseLogEntryResponse> exerciseLogEntries;
}
