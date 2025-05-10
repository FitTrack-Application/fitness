package com.hcmus.statisticservice.infrastructure.repository;

import com.hcmus.statisticservice.domain.model.StepLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface JpaStepLogRepository extends JpaRepository<StepLog, UUID> {
    List<StepLog> findByUserId(UUID userId);

    List<StepLog> findByUserIdAndDateBetweenOrderByDateDesc(UUID userId, Date startDate, Date endDate);

    Optional<StepLog> findByUserIdAndDate(UUID userId, Date date);
}