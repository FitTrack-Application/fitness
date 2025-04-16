package com.hcmus.fitservice.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class FoodScanResponse {
    private String productName;
    private String image;
    private String servingSize;
    private NutrimentsDto nutriments;
}
