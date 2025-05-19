package com.hcmus.statisticservice.domain.repository;

import com.hcmus.statisticservice.domain.model.WeightLog;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface WeightLogRepository {
    WeightLog save(WeightLog weightLog);

    List<WeightLog> findByUserId(UUID userId);

    List<WeightLog> findByUserIdAndDateBetweenOrderByDateDesc(UUID userId, LocalDate startDate,
            LocalDate endDate);

    Optional<WeightLog> findByUserIdAndDate(UUID userId, LocalDate date);

    Optional<WeightLog> findFirstByUserIdOrderByDateDesc(UUID userId);

    void deleteById(UUID id);
}