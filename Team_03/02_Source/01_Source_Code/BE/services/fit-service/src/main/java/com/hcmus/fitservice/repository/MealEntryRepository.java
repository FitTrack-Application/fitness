package com.hcmus.fitservice.repository;

import com.hcmus.fitservice.model.MealEntry;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface MealEntryRepository extends JpaRepository<MealEntry, UUID> {
}
