package com.hcmus.statisticservice.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.*;

import java.util.Date;

@Setter
@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class WeightLogRequest {

    @NotBlank(message = "Weight is required")
    private Double weight;

    @NotBlank(message = "Update date is required")
    private Date updateDate;

    private String progressPhoto;
}
