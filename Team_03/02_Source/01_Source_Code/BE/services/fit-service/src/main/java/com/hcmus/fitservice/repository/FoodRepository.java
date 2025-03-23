package com.hcmus.fitservice.repository;

import com.hcmus.fitservice.db.model.Food;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface FoodRepository extends JpaRepository<Food, UUID> {
    List<Food> findByFoodNameContainingIgnoreCase(String foodName);
}