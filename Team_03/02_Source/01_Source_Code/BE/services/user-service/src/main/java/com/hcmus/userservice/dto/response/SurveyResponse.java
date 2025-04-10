package com.hcmus.userservice.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;
import java.lang.String;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class SurveyResponse {
    private UUID userId;
    private UUID goalId;
    private String message;
}