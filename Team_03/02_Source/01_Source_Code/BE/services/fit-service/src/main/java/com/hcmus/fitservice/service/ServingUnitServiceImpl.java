package com.hcmus.fitservice.service;

import com.hcmus.fitservice.dto.response.ApiResponse;
import com.hcmus.fitservice.dto.response.ServingUnitResponse;
import com.hcmus.fitservice.model.ServingUnit;
import com.hcmus.fitservice.repository.ServingUnitRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@RequiredArgsConstructor
@Service
public class ServingUnitServiceImpl implements ServingUnitService{

    private final ServingUnitRepository servingUnitRepository;

    @Override
    public ApiResponse<List<ServingUnitResponse>> getAllServingUnits(){
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
                .timestamp(LocalDateTime.now())
                .build();
    }

    @Override
    public ApiResponse<ServingUnitResponse> getServingUnitById(UUID servingUnitId) {
        ServingUnit servingUnit = servingUnitRepository.findById(servingUnitId)
                .orElseThrow(() -> new RuntimeException("Serving unit not found"));

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
                .timestamp(LocalDateTime.now())
                .build();
    }
}
