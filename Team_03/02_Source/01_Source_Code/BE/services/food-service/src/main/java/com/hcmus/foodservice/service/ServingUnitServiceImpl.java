package com.hcmus.foodservice.service;

import com.hcmus.foodservice.dto.response.ApiResponse;
import com.hcmus.foodservice.dto.response.ServingUnitResponse;
import com.hcmus.foodservice.exception.ResourceNotFoundException;
import com.hcmus.foodservice.model.ServingUnit;
import com.hcmus.foodservice.repository.ServingUnitRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@RequiredArgsConstructor
@Service
public class ServingUnitServiceImpl implements ServingUnitService {

    private final ServingUnitRepository servingUnitRepository;

    @Override
    public ApiResponse<List<ServingUnitResponse>> getAllServingUnits() {
        List<ServingUnit> servingUnits = servingUnitRepository.findAll();

        // Convert to Dto
        List<ServingUnitResponse> servingUnitResponses = servingUnits.stream()
                .map(servingUnit -> ServingUnitResponse.builder()
                        .id(servingUnit.getServingUnitId())
                        .unitName(servingUnit.getUnitName())
                        .unitSymbol(servingUnit.getUnitSymbol())
                        .build())
                .toList();

        return ApiResponse.<List<ServingUnitResponse>>builder()
                .status(200)
                .generalMessage("Successfully retrieved all serving units")
                .data(servingUnitResponses)
                .build();
    }

    @Override
    public ApiResponse<ServingUnitResponse> getServingUnitById(UUID servingUnitId) {
        ServingUnit servingUnit = servingUnitRepository.findById(servingUnitId)
                .orElseThrow(() -> new ResourceNotFoundException("Serving unit not found"));

        // Convert to Dto
        ServingUnitResponse servingUnitResponse = ServingUnitResponse.builder()
                .id(servingUnit.getServingUnitId())
                .unitName(servingUnit.getUnitName())
                .unitSymbol(servingUnit.getUnitSymbol())
                .build();

        return ApiResponse.<ServingUnitResponse>builder()
                .status(200)
                .generalMessage("Successfully retrieved serving unit")
                .data(servingUnitResponse)
                .build();
    }
}
