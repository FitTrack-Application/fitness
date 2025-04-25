package com.hcmus.fitservice.controller;

import com.hcmus.fitservice.dto.FoodDto;
import com.hcmus.fitservice.dto.response.ApiResponse;
import com.hcmus.fitservice.service.FoodService;
import com.hcmus.fitservice.util.JwtUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.UUID;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/foods")
public class FoodController {

    private final FoodService foodService;
    private final JwtUtil jwtUtil;

    @GetMapping("/test-user")
    public Map<String, Object> getUserInfo(@AuthenticationPrincipal Jwt jwt) {
        return Map.of(
                "drUserId", jwt.getSubject(),
                "drEmail", jwt.getClaimAsString("email"),
                "drUsername", jwt.getClaimAsString("preferred_username"),
                "userId", jwtUtil.getCurrentUserId(),
                "email", jwtUtil.getCurrentUserEmail(),
                "allClaims", jwtUtil.getAllClaims()
        );
    }

    @GetMapping("/test-admin")
    public Map<String, Object> getAdminInfo() {
        return Map.of(
                "userId", jwtUtil.getCurrentUserId(),
                "email", jwtUtil.getCurrentUserEmail(),
                "allClaims", jwtUtil.getAllClaims()
        );
    }

    // Get food by id
    @GetMapping("/{foodId}")
    public ResponseEntity<ApiResponse<FoodDto>> getFoodById(@PathVariable UUID foodId) {
        ApiResponse<FoodDto> response = foodService.getFoodById(foodId);
        return ResponseEntity.ok(response);
    }

    // Get foods with pagination (The search is not perfectly with UTF-8)
    @GetMapping
    public ResponseEntity<ApiResponse<List<FoodDto>>> getFoods(
            @RequestParam(required = false) String query,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size
    ) {
        Pageable pageable = PageRequest.of(page - 1, size);
        ApiResponse<List<FoodDto>> response;

        // If query is not provided or empty, return all foods
        if (query == null || query.isEmpty()) {
            response = foodService.getAllFoods(pageable);
        } else {
            response = foodService.searchFoodsByName(query, pageable);
        }

        return ResponseEntity.ok(response);
    }


    @GetMapping("/scan")
    public ResponseEntity<ApiResponse<FoodDto>> getMethodName(@RequestParam String barcode) {
        ApiResponse<FoodDto> response = foodService.scanFood(barcode);

        return ResponseEntity.ok(response);
    }
//
//    @PutMapping("/add")
//    public ResponseEntity<ApiResponse<?>> addFood(@Valid @RequestBody FoodDto foodDto, @RequestHeader("Authorization") String authorizationHeader) {
//
//        UUID userId = jwtUtil.extractUserId(authorizationHeader.replace("Bearer ", ""));
//        ApiResponse<?> response = foodService.addFood(foodDto, userId);
//        return ResponseEntity.ok(response);
//    }

}
