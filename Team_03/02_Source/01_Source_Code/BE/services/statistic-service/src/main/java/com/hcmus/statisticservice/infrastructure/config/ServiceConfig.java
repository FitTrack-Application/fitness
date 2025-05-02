package com.hcmus.statisticservice.infrastructure.config;

import com.hcmus.statisticservice.domain.service.WeightCalculationService;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class ServiceConfig {

    @Bean
    public WeightCalculationService weightCalculationService() {
        return new WeightCalculationService();
    }
}