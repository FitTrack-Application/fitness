package com.hcmus.foodservice.repository;

import com.hcmus.foodservice.model.MealEntry;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface MealEntryRepository extends JpaRepository<MealEntry, UUID> {
}
