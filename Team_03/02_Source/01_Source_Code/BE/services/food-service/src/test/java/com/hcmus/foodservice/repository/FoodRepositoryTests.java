package com.hcmus.foodservice.repository;

import com.hcmus.foodservice.model.Food;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;

import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;

@DataJpaTest
public class FoodRepositoryTests {

    @Autowired
    private FoodRepository foodRepository;

    @Test
    void FoodRepository_findByUserIdIsNullAndFoodNameContainingIgnoreCase_ReturnsMatchingFoods() {
        foodRepository.save(new Food(null, "Chicken Breast", 165, 31.0, 0.0, 3.6, null, null));
        foodRepository.save(new Food(null, "Grilled Chicken", 200, 27.0, 0.0, 7.0, null, null));
        foodRepository.save(new Food(null, "Beef", 200, 20.0, 0.0, 10.0, null, UUID.randomUUID()));

        Page<Food> result = foodRepository.findByUserIdIsNullAndFoodNameContainingIgnoreCase("chicken", PageRequest.of(0, 10));

        assertThat(result.getTotalElements()).isEqualTo(2);
    }

    @Test
    void FoodRepository_findByUserIdIsNull_ReturnsPublicFoods() {
        foodRepository.save(new Food(null, "Apple", 52, 0.3, 14.0, 0.2, null, null));
        foodRepository.save(new Food(null, "Orange", 47, 0.9, 12.0, 0.1, null, null));
        foodRepository.save(new Food(null, "Private Food", 100, 10.0, 10.0, 10.0, null, UUID.randomUUID()));

        Page<Food> result = foodRepository.findByUserIdIsNull(PageRequest.of(0, 10));

        assertThat(result.getContent().size()).isEqualTo(2);
    }

    @Test
    void FoodRepository_findByUserIdAndFoodNameContainingIgnoreCase_ReturnsUserFoodsMatchingName() {
        UUID userId = UUID.randomUUID();
        foodRepository.save(new Food(null, "Egg Salad", 150, 6.0, 2.0, 10.0, null, userId));
        foodRepository.save(new Food(null, "Egg Fried Rice", 180, 5.0, 20.0, 8.0, null, userId));
        foodRepository.save(new Food(null, "Other Food", 120, 3.0, 15.0, 5.0, null, UUID.randomUUID()));

        Page<Food> result = foodRepository.findByUserIdAndFoodNameContainingIgnoreCase(userId, "egg", PageRequest.of(0, 10));

        assertThat(result.getTotalElements()).isEqualTo(2);
    }

    @Test
    void FoodRepository_findByUserId_ReturnsUserFoods() {
        UUID userId = UUID.randomUUID();
        foodRepository.save(new Food(null, "UserFood1", 100, 10.0, 5.0, 1.0, null, userId));
        foodRepository.save(new Food(null, "UserFood2", 200, 20.0, 10.0, 2.0, null, userId));

        Page<Food> result = foodRepository.findByUserId(userId, PageRequest.of(0, 10));

        assertThat(result.getContent().size()).isEqualTo(2);
    }

    @Test
    void FoodRepository_findByFoodIdAndUserId_ReturnsMatchingFood() {
        UUID userId = UUID.randomUUID();
        Food savedFood = foodRepository.save(new Food(null, "TestFood", 100, 5.0, 5.0, 5.0, null, userId));

        Food result = foodRepository.findByFoodIdAndUserId(savedFood.getFoodId(), userId);

        assertThat(result).isNotNull();
        assertThat(result.getFoodName()).isEqualTo("TestFood");
    }

    @Test
    void FoodRepository_findByFoodId_ReturnsFoodIfExists() {
        Food saved = foodRepository.save(new Food(null, "Banana", 89, 1.1, 23.0, 0.3, null, null));

        Food found = foodRepository.findByFoodId(saved.getFoodId());

        assertThat(found).isNotNull();
        assertThat(found.getFoodName()).isEqualTo("Banana");
    }

    @Test
    void FoodRepository_existsByFoodIdAndUserIdIsNotNull_ReturnsTrueIfUserFoodExists() {
        UUID userId = UUID.randomUUID();
        Food food = foodRepository.save(new Food(null, "PrivateFood", 100, 5.0, 5.0, 5.0, null, userId));

        boolean exists = foodRepository.existsByFoodIdAndUserIdIsNotNull(food.getFoodId());

        assertThat(exists).isTrue();
    }

    @Test
    void FoodRepository_existsByFoodIdAndUserIdIsNotNull_ReturnsFalseIfFoodIsPublic() {
        Food food = foodRepository.save(new Food(null, "PublicFood", 90, 4.0, 4.0, 4.0, null, null));

        boolean exists = foodRepository.existsByFoodIdAndUserIdIsNotNull(food.getFoodId());

        assertThat(exists).isFalse();
    }
}
