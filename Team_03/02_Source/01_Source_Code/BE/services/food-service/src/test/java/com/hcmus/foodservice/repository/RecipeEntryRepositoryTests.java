package com.hcmus.foodservice.repository;

import com.hcmus.foodservice.model.Food;
import com.hcmus.foodservice.model.Recipe;
import com.hcmus.foodservice.model.RecipeEntry;
import com.hcmus.foodservice.model.ServingUnit;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;

import java.util.List;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;

@DataJpaTest
public class RecipeEntryRepositoryTests {

    @Autowired
    private RecipeEntryRepository recipeEntryRepository;

    @Autowired
    private RecipeRepository recipeRepository;

    @Autowired
    private FoodRepository foodRepository;

    @Autowired
    private ServingUnitRepository servingUnitRepository;

    @Test
    void RecipeEntryRepository_deleteAllByRecipe_RemovesEntriesForGivenRecipe() {
        Recipe recipe = new Recipe();
        recipe.setRecipeName("Test Recipe");
        recipe.setDirection("Test directions");
        recipe.setUserId(UUID.randomUUID());
        recipe = recipeRepository.save(recipe);

        Food food = new Food();
        food.setFoodName("Test Food");
        food.setCaloriesPer100g(100);
        food.setProteinPer100g(10.0);
        food.setCarbsPer100g(20.0);
        food.setFatPer100g(5.0);
        food = foodRepository.save(food);

        ServingUnit servingUnit = new ServingUnit();
        servingUnit.setUnitName("Gram");
        servingUnit.setUnitSymbol("g");
        servingUnit.setConversionToGrams(1.0);
        servingUnit = servingUnitRepository.save(servingUnit);

        RecipeEntry entry1 = new RecipeEntry();
        entry1.setRecipe(recipe);
        entry1.setFood(food);
        entry1.setNumberOfServings(2.0);
        entry1.setServingUnit(servingUnit);
        recipeEntryRepository.save(entry1);

        RecipeEntry entry2 = new RecipeEntry();
        entry2.setRecipe(recipe);
        entry2.setFood(food);
        entry2.setNumberOfServings(3.0);
        entry2.setServingUnit(servingUnit);
        recipeEntryRepository.save(entry2);

        List<RecipeEntry> entriesBefore = recipeEntryRepository.findAll();
        assertThat(entriesBefore).hasSize(2);

        recipeEntryRepository.deleteAllByRecipe(recipe);

        List<RecipeEntry> entriesAfter = recipeEntryRepository.findAll();
        assertThat(entriesAfter).isEmpty();
    }
}
