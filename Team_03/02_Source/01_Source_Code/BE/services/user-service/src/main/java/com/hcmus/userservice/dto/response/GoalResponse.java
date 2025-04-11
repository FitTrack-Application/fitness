package com.hcmus.userservice.dto.response;

import java.util.UUID;

import lombok.*;

@Setter
@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class GoalResponse {

    private UUID goalId;
}