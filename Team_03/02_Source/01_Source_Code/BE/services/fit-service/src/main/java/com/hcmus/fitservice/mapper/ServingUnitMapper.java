package com.hcmus.fitservice.mapper;

import com.hcmus.fitservice.dto.response.ServingUnitResponse;
import com.hcmus.fitservice.model.ServingUnit;
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
