package com.hcmus.foodservice.dto;

import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@Builder
@Getter
@Setter
public class TopFoodDto {
    private String name;

    private Integer count;
}
