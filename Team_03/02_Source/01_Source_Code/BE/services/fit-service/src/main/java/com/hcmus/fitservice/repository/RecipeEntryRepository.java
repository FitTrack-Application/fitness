package com.hcmus.fitservice.repository;

import com.hcmus.fitservice.model.RecipeEntry;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface RecipeEntryRepository extends JpaRepository<RecipeEntry, UUID> {
}