package com.hcmus.statisticservice.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.hcmus.statisticservice.model.WeightLog;

import java.util.List;
import java.util.UUID;

@Repository
public interface WeightLogRepository extends JpaRepository<WeightLog, UUID> {

    List<WeightLog> findByUserId(UUID userId);

    WeightLog findFirstByUserIdOrderByDateDesc(UUID userId);
}
