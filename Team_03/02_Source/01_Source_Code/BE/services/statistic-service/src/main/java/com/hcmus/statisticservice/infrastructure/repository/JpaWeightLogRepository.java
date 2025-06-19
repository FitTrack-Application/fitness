package com.hcmus.statisticservice.infrastructure.repository;

import com.hcmus.statisticservice.domain.model.WeightLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface JpaWeightLogRepository extends JpaRepository<WeightLog, UUID> {
    List<WeightLog> findByUserId(UUID userId);

    List<WeightLog> findByUserIdAndDateBetweenOrderByDateDesc(UUID userId, LocalDate startDate,
                                                              LocalDate endDate);

    Optional<WeightLog> findByUserIdAndDate(UUID userId, LocalDate date);

    Optional<WeightLog> findFirstByUserIdOrderByDateDesc(UUID userId);
}