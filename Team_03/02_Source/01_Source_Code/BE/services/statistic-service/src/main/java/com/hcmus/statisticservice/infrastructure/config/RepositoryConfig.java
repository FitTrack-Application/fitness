package com.hcmus.statisticservice.infrastructure.config;

import com.hcmus.statisticservice.domain.repository.*;
import com.hcmus.statisticservice.infrastructure.repository.*;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class RepositoryConfig {

    @Bean
    public WeightLogRepository weightLogRepository(JpaWeightLogRepository jpaWeightLogRepository) {
        return new WeightLogRepositoryAdapter(jpaWeightLogRepository);
    }

    @Bean
    public WeightGoalRepository weightGoalRepository(JpaWeightGoalRepository jpaWeightGoalRepository) {
        return new WeightGoalRepositoryAdapter(jpaWeightGoalRepository);
    }

    @Bean
    public StepLogRepository stepLogRepository(JpaStepLogRepository jpaStepLogRepository) {
        return new StepLogRepositoryAdapter(jpaStepLogRepository);
    }

    @Bean
    public NutritionGoalRepository nutritionGoalRepository(JpaNutritionGoalRepository jpaNutritionGoalRepository) {
        return new NutritionGoalRepositoryAdapter(jpaNutritionGoalRepository);
    }

    @Bean
    public FitProfileRepository fitProfileRepository(JpaFitProfileRepository jpaFitProfileRepository) {
        return new FitProfileRepositoryAdapter(jpaFitProfileRepository);
    }

    @Bean
    public LatestLoginRepository latestLoginRepository(JpaLatestLoginRepository jpaLatestLoginRepository) {
        return new LatestLoginRepositoryAdapter(jpaLatestLoginRepository);
    }
}