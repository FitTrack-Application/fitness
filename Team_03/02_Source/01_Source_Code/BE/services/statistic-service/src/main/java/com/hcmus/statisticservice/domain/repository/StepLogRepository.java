package com.hcmus.statisticservice.domain.repository;

import com.hcmus.statisticservice.domain.model.StepLog;

import java.util.Date;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface StepLogRepository {
    StepLog save(StepLog stepLog);

    Optional<StepLog> findByUserIdAndDate(UUID userId, Date date);

    List<StepLog> findByUserIdAndDateBetweenOrderByDateDesc(UUID userId, Date startDate, Date endDate);

    void deleteById(UUID id);
}