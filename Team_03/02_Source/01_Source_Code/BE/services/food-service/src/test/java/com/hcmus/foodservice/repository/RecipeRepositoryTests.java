package com.hcmus.foodservice.repository;

import com.hcmus.foodservice.model.*;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.data.domain.*;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;

@DataJpaTest
public class RecipeRepositoryTests {

    @Autowired
    private RecipeRepository recipeRepository;

    @Autowired
    private FoodRepository foodRepository;

    @Autowired
    private ServingUnitRepository servingUnitRepository;

    private Recipe createRecipe(UUID userId, String name) {
        Recipe recipe = new Recipe();
        recipe.setRecipeName(name);
        recipe.setDirection("Mix all ingredients");
        recipe.setUserId(userId);
        return recipeRepository.save(recipe);
    }

    private Recipe createRecipeWithEntries(UUID userId, String name) {
        Recipe recipe = createRecipe(userId, name);

        Food food = new Food();
        food.setFoodName("Chicken");
        food.setCaloriesPer100g(239);
        food.setProteinPer100g(27.0);
        food.setCarbsPer100g(0.0);
        food.setFatPer100g(14.0);
        food = foodRepository.save(food);

        ServingUnit unit = new ServingUnit();
        unit.setUnitName("Gram");
        unit.setUnitSymbol("g");
        unit.setConversionToGrams(1.0);
        unit = servingUnitRepository.save(unit);

        // Create entry
        RecipeEntry entry = new RecipeEntry();
        entry.setRecipe(recipe);
        entry.setFood(food);
        entry.setNumberOfServings(2.0);
        entry.setServingUnit(unit);

        recipe.setRecipeEntries(List.of(entry));

        return recipeRepository.save(recipe);
    }

    @Test
    void RecipeRepository_findAllByUserId_ReturnsRecipesByUser() {
        UUID userId = UUID.randomUUID();
        createRecipe(userId, "Salad");
        createRecipe(userId, "Grilled Chicken");
        createRecipe(UUID.randomUUID(), "Should not appear");

        Pageable pageable = PageRequest.of(0, 10, Sort.by("recipeName"));

        Page<Recipe> result = recipeRepository.findAllByUserId(userId, pageable);

        assertThat(result.getTotalElements()).isEqualTo(2);
        assertThat(result.getContent()).extracting(Recipe::getRecipeName)
                .containsExactlyInAnyOrder("Salad", "Grilled Chicken");
    }

    @Test
    void RecipeRepository_findByRecipeIdAndUserId_ReturnsCorrectRecipe() {
        UUID userId = UUID.randomUUID();
        Recipe recipe = createRecipe(userId, "Omelette");

        Optional<Recipe> found = recipeRepository.findByRecipeIdAndUserId(recipe.getRecipeId(), userId);

        assertThat(found).isPresent();
        assertThat(found.get().getRecipeName()).isEqualTo("Omelette");
    }

    @Test
    void RecipeRepository_findByUserIdAndRecipeNameContainingIgnoreCase_ReturnsMatchingRecipes() {
        UUID userId = UUID.randomUUID();
        createRecipe(userId, "Beef Stew");
        createRecipe(userId, "Stewed Pork");
        createRecipe(userId, "Grilled Fish");

        Pageable pageable = PageRequest.of(0, 10);

        Page<Recipe> result = recipeRepository.findByUserIdAndRecipeNameContainingIgnoreCase(userId, "stew", pageable);

        assertThat(result.getTotalElements()).isEqualTo(2);
        assertThat(result.getContent()).extracting(Recipe::getRecipeName)
                .containsExactlyInAnyOrder("Beef Stew", "Stewed Pork");
    }

}
