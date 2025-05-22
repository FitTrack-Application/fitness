package com.hcmus.foodservice.repository;

import com.hcmus.foodservice.model.Food;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface FoodRepository extends JpaRepository<Food, UUID> {
    Page<Food> findByUserIdIsNullAndFoodNameContainingIgnoreCase(String name, Pageable pageable);

    Page<Food> findByUserIdIsNull(Pageable pageable);

    Page<Food> findByUserIdAndFoodNameContainingIgnoreCase(UUID userId, String name, Pageable pageable);

    Page<Food> findByUserId(UUID userId, Pageable pageable);

    Food findByFoodIdAndUserId(UUID foodId, UUID userId);

    Food findByFoodId(UUID foodId);

    boolean existsByFoodIdAndUserIdIsNotNull(UUID foodId);

}
