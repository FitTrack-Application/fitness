package com.hcmus.fitservice.repository;

import com.hcmus.fitservice.model.Food;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface FoodRepository extends JpaRepository<Food, UUID> {
}
