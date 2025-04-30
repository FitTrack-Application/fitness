package com.hcmus.fitservice.service;

import com.hcmus.fitservice.dto.response.ApiResponse;
import com.hcmus.fitservice.dto.response.ServingUnitResponse;

import java.util.List;
import java.util.UUID;

public interface ServingUnitService {
    ApiResponse<List<ServingUnitResponse>> getAllServingUnits();

    ApiResponse<ServingUnitResponse> getServingUnitById(UUID servingUnitId);
}
