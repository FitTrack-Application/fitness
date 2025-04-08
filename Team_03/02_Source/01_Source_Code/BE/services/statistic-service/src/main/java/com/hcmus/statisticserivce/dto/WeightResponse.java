package com.hcmus.statisticserivce.dto;

import java.util.List;
import com.hcmus.statisticserivce.dto.WeightProgressDto;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class WeightResponse {
    
    private String message;
    private List<WeightProgressDto> data;
}
