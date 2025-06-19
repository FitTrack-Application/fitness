package com.hcmus.foodservice.mapper;

import com.hcmus.foodservice.dto.response.ServingUnitResponse;
import com.hcmus.foodservice.model.ServingUnit;
import org.springframework.stereotype.Component;

@Component
public class ServingUnitMapper {

    public ServingUnitResponse convertToServingUnitResponse(ServingUnit servingUnit) {
        return ServingUnitResponse.builder()
                .id(servingUnit.getServingUnitId())
                .unitName(servingUnit.getUnitName())
                .unitSymbol(servingUnit.getUnitSymbol())
                .build();
    }
}
