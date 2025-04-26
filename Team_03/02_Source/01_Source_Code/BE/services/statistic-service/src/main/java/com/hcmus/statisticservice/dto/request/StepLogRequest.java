package com.hcmus.statisticservice.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.*;

import java.util.Date;

@Setter
@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class StepLogRequest {

    @NotBlank(message = "Weight is required")
    private Integer steps;

    @NotBlank(message = "Update date is required")
    private Date updateDate;
}
