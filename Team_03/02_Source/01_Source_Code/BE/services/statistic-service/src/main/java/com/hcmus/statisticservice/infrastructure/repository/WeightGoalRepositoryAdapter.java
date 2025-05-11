package com.hcmus.statisticservice.infrastructure.repository;

import com.hcmus.statisticservice.domain.model.WeightGoal;
import com.hcmus.statisticservice.domain.repository.WeightGoalRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.Optional;
import java.util.UUID;

@Component
@RequiredArgsConstructor
public class WeightGoalRepositoryAdapter implements WeightGoalRepository {

    private final JpaWeightGoalRepository jpaWeightGoalRepository;

    @Override
    public WeightGoal save(WeightGoal weightGoal) {
        return jpaWeightGoalRepository.save(weightGoal);
    }

    @Override
    public Optional<WeightGoal> findByUserId(UUID userId) {
        return jpaWeightGoalRepository.findTopByUserIdOrderByStartingDateDesc(userId);
    }

    @Override
    public boolean existsByUserId(UUID userId) {
        return jpaWeightGoalRepository.existsByUserId(userId);
    }

    @Override
    public void deleteById(UUID id) {
        jpaWeightGoalRepository.deleteById(id);
    }
}