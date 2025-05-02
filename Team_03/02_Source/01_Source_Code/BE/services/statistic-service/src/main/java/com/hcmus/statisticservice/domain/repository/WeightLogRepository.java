package com.hcmus.statisticservice.domain.repository;

import com.hcmus.statisticservice.domain.model.WeightLog;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface WeightLogRepository {
    WeightLog save(WeightLog weightLog);

    List<WeightLog> findByUserId(UUID userId);

    List<WeightLog> findByUserIdAndDateBetweenOrderByDateDesc(UUID userId, LocalDateTime startDate,
            LocalDateTime endDate);

    Optional<WeightLog> findByUserIdAndDate(UUID userId, LocalDateTime date);

    Optional<WeightLog> findFirstByUserIdOrderByDateDesc(UUID userId);

    void deleteById(UUID id);
}