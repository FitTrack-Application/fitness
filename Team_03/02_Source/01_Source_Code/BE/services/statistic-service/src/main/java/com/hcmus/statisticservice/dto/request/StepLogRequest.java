package com.hcmus.statisticservice.dto.request;

import jakarta.validation.constraints.NotNull;
import lombok.*;

import java.util.Date;

@Setter
@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class StepLogRequest {

    @NotNull(message = "Weight is required")
    private Integer steps;

    @NotNull(message = "Update date is required")
    private Date updateDate;
}
