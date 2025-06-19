package com.hcmus.statisticservice.infrastructure.repository;

import com.hcmus.statisticservice.domain.model.StepLog;
import com.hcmus.statisticservice.domain.repository.StepLogRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.Date;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Component
@RequiredArgsConstructor
public class StepLogRepositoryAdapter implements StepLogRepository {

    private final JpaStepLogRepository jpaStepLogRepository;

    @Override
    public StepLog save(StepLog stepLog) {
        return jpaStepLogRepository.save(stepLog);
    }

    @Override
    public Optional<StepLog> findByUserIdAndDate(UUID userId, Date date) {
        return jpaStepLogRepository.findByUserIdAndDate(userId, date);
    }

    @Override
    public List<StepLog> findByUserIdAndDateBetweenOrderByDateDesc(UUID userId, Date startDate, Date endDate) {
        return jpaStepLogRepository.findByUserIdAndDateBetweenOrderByDateDesc(userId, startDate, endDate);
    }

    @Override
    public void deleteById(UUID id) {
        jpaStepLogRepository.deleteById(id);
    }
}