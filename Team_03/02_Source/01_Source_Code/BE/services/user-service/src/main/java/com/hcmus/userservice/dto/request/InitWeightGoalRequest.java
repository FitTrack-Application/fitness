package com.hcmus.userservice.dto.request;

import lombok.*;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class InitWeightGoalRequest {

    private Double startingWeight;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date startingDate;

    private Double goalWeight;

    private Double weeklyGoal;
}
