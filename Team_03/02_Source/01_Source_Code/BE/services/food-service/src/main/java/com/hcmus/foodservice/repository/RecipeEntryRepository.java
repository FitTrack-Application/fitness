package com.hcmus.foodservice.repository;

import com.hcmus.foodservice.model.Recipe;
import com.hcmus.foodservice.model.RecipeEntry;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface RecipeEntryRepository extends JpaRepository<RecipeEntry, UUID> {
    void deleteAllByRecipe(Recipe recipe);
}