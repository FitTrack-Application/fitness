package com.hcmus.statisticserivce.dto;

import lombok.*;

import java.time.LocalDate;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class WeightProgressDto {

    private LocalDate updateDate;

    private Double weight;

    private String progressPhoto;
}
