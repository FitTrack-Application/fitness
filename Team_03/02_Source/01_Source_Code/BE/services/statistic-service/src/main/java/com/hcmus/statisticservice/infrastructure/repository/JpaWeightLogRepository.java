package com.hcmus.statisticservice.infrastructure.repository;

import com.hcmus.statisticservice.domain.model.WeightLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface JpaWeightLogRepository extends JpaRepository<WeightLog, UUID> {
    List<WeightLog> findByUserId(UUID userId);

    List<WeightLog> findByUserIdAndDateBetweenOrderByDateDesc(UUID userId, LocalDateTime startDate,
            LocalDateTime endDate);

    Optional<WeightLog> findByUserIdAndDate(UUID userId, LocalDateTime date);

    Optional<WeightLog> findFirstByUserIdOrderByDateDesc(UUID userId);
}