package com.hcmus.foodservice.service;

import com.hcmus.foodservice.dto.response.ApiResponse;
import com.hcmus.foodservice.dto.response.ServingUnitResponse;

import java.util.List;
import java.util.UUID;

public interface ServingUnitService {
    ApiResponse<List<ServingUnitResponse>> getAllServingUnits();

    ApiResponse<ServingUnitResponse> getServingUnitById(UUID servingUnitId);
}
