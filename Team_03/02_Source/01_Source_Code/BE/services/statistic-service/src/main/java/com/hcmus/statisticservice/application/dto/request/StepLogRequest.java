package com.hcmus.statisticservice.application.dto.request;

import jakarta.validation.constraints.NotNull;
import lombok.*;

import java.util.Date;

@Setter
@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class StepLogRequest {
    @NotNull(message = "Steps is required")
    private Integer steps;

    @NotNull(message = "Date is required")
    private Date date;
}