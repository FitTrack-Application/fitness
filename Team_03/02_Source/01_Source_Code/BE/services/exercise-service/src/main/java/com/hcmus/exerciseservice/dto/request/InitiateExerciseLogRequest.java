package com.hcmus.exerciseservice.dto.request;

import lombok.*;

import java.util.Date;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
public class InitiateExerciseLogRequest {
    private Date date;
}
