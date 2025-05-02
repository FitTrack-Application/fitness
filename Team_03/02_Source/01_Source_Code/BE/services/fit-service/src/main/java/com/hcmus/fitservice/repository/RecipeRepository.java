package com.hcmus.fitservice.repository;

import com.hcmus.fitservice.model.Recipe;
import feign.Param;
import jakarta.transaction.Transactional;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.Optional;
import java.util.UUID;

public interface RecipeRepository extends JpaRepository<Recipe, UUID> {
    Page<Recipe> findAllByUserId(UUID userId, Pageable pageable);

    Optional<Recipe> findByRecipeIdAndUserId(UUID recipeId, UUID userId);

    Page<Recipe> findByUserIdAndRecipeNameContainingIgnoreCase(UUID userId, String name, Pageable pageable);

//    @Transactional
//    @Query("SELECT r FROM Recipe r LEFT JOIN FETCH r.recipeEntries WHERE r.recipeId = :recipeId")
//    Optional<Recipe> findByIdWithEntries(@Param("recipeId") UUID recipeId);


}