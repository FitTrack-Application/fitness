package com.hcmus.foodservice.repository;

import com.hcmus.foodservice.model.Recipe;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface RecipeRepository extends JpaRepository<Recipe, UUID> {
    Page<Recipe> findAllByUserId(UUID userId, Pageable pageable);

    Optional<Recipe> findByRecipeIdAndUserId(UUID recipeId, UUID userId);

    Page<Recipe> findByUserIdAndRecipeNameContainingIgnoreCase(UUID userId, String name, Pageable pageable);

}