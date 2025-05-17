package com.hcmus.foodservice.controller;

import com.hcmus.foodservice.dto.response.ApiResponse;
import com.hcmus.foodservice.dto.response.ServingUnitResponse;
import com.hcmus.foodservice.service.ServingUnitService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.UUID;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/serving-units")
public class ServingUnitController {

    private final ServingUnitService servingUnitService;

    @GetMapping
    public ResponseEntity<ApiResponse<List<ServingUnitResponse>>> getAllServingUnits() {
        return ResponseEntity.ok(servingUnitService.getAllServingUnits());
    }

    @GetMapping("/{servingUnitId}")
    public ResponseEntity<ApiResponse<ServingUnitResponse>> getServingUnitById(@PathVariable UUID servingUnitId) {
        return ResponseEntity.ok(servingUnitService.getServingUnitById(servingUnitId));
    }
}
