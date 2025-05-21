package com.hcmus.foodservice.dto.response;

import lombok.*;

import java.util.UUID;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ServingUnitResponse {

    private UUID id;

    private String unitName;

    private String unitSymbol;
}
