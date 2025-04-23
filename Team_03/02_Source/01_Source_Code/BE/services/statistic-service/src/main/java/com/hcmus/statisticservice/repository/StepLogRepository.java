package com.hcmus.statisticservice.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.hcmus.statisticservice.model.StepLog;

import java.util.List;
import java.util.UUID;

@Repository
public interface StepLogRepository extends JpaRepository<StepLog, UUID> {
    List<StepLog> findByUserId(UUID userId);
}
