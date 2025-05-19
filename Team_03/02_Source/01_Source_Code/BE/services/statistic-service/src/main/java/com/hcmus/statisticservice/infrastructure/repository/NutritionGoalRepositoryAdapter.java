package com.hcmus.statisticservice.infrastructure.repository;

import com.hcmus.statisticservice.domain.model.NutritionGoal;
import com.hcmus.statisticservice.domain.repository.NutritionGoalRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.Optional;
import java.util.UUID;

@Component
@RequiredArgsConstructor
public class NutritionGoalRepositoryAdapter implements NutritionGoalRepository {

    private final JpaNutritionGoalRepository jpaNutritionGoalRepository;

    @Override
    public NutritionGoal save(NutritionGoal nutritionGoal) {
        return jpaNutritionGoalRepository.save(nutritionGoal);
    }

    @Override
    public Optional<NutritionGoal> findByUserId(UUID userId) {
        return jpaNutritionGoalRepository.findByUserId(userId);
    }

    @Override
    public void deleteById(UUID id) {
        jpaNutritionGoalRepository.deleteById(id);
    }
}