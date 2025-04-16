package com.hcmus.statisticservice.dto.request;

import lombok.*;

import java.util.Date;

import jakarta.validation.constraints.NotBlank;

@Setter
@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class AddWeightRequest {

    @NotBlank(message = "Weight is required")
    private Double weight;

    @NotBlank(message = "Update date is required")
    private Date updateDate; 

    private String progressPhoto;
    
}
