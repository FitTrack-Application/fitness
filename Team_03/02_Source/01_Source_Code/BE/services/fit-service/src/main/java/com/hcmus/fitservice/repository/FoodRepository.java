package com.hcmus.fitservice.repository;

import com.hcmus.fitservice.model.Food;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface FoodRepository extends JpaRepository<Food, UUID> {
    Page<Food> findByFoodNameContainingIgnoreCase(String name, Pageable pageable);
    Food findByFoodIdAndUserId(UUID foodId, UUID userId);
}
