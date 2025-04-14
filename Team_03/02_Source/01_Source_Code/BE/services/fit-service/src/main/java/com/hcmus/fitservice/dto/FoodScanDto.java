package com.hcmus.fitservice.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Builder
@Data
public class FoodScanDto {

    private String productName;
    private String image;
    private String servingSize;
    private NutrimentsDto nutriments;

}
    