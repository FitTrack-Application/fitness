package com.hcmus.statisticservice.application.dto.request;

import jakarta.validation.constraints.NotNull;
import lombok.*;

import java.util.Date;

@Setter
@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class WeightLogRequest {

    @NotNull(message = "Weight is required")
    private Double weight;

    @NotNull(message = "Update date is required")
    private Date updateDate;

    private String progressPhoto;
}