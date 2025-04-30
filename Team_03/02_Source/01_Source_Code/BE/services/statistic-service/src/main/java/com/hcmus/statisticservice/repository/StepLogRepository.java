package com.hcmus.statisticservice.repository;

import com.hcmus.statisticservice.model.StepLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface StepLogRepository extends JpaRepository<StepLog, UUID> {

    Optional<StepLog> findByUserIdAndDate(UUID userId, Date date);

    List<StepLog> findByUserIdAndDateBetweenOrderByDateDesc(UUID userId, Date startDate, Date endDate);
}
