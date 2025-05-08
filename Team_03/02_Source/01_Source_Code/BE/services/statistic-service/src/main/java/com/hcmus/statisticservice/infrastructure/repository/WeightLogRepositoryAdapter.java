package com.hcmus.statisticservice.infrastructure.repository;

import com.hcmus.statisticservice.domain.model.WeightLog;
import com.hcmus.statisticservice.domain.repository.WeightLogRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Date;
import java.util.Optional;
import java.util.UUID;

@Component
@RequiredArgsConstructor
public class WeightLogRepositoryAdapter implements WeightLogRepository {

    private final JpaWeightLogRepository jpaWeightLogRepository;

    @Override
    public WeightLog save(WeightLog weightLog) {
        return jpaWeightLogRepository.save(weightLog);
    }

    @Override
    public List<WeightLog> findByUserId(UUID userId) {
        return jpaWeightLogRepository.findByUserId(userId);
    }

    @Override
    public List<WeightLog> findByUserIdAndDateBetweenOrderByDateDesc(UUID userId, Date startDate,
            Date endDate) {
        return jpaWeightLogRepository.findByUserIdAndDateBetweenOrderByDateDesc(userId, startDate, endDate);
    }

    @Override
    public Optional<WeightLog> findByUserIdAndDate(UUID userId, LocalDateTime date) {
        return jpaWeightLogRepository.findByUserIdAndDate(userId, date);
    }

    @Override
    public Optional<WeightLog> findFirstByUserIdOrderByDateDesc(UUID userId) {
        return jpaWeightLogRepository.findFirstByUserIdOrderByDateDesc(userId);
    }

    @Override
    public void deleteById(UUID id) {
        jpaWeightLogRepository.deleteById(id);
    }
}