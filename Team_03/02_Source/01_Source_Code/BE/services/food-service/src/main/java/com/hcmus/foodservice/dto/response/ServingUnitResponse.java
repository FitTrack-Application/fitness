package com.hcmus.foodservice.dto.response;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.util.UUID;

@Getter
@Setter
@Builder
public class ServingUnitResponse {

    private UUID id;

    private String unitName;

    private String unitSymbol;
}
