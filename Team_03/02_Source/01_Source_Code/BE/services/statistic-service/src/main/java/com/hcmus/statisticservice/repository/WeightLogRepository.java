package com.hcmus.statisticservice.repository;

import com.hcmus.statisticservice.model.WeightLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface WeightLogRepository extends JpaRepository<WeightLog, UUID> {

    List<WeightLog> findByUserId(UUID userId);

    List<WeightLog> findByUserIdAndDateBetweenOrderByDateDesc(UUID userId, Date startDate, Date endDate);

    Optional<WeightLog> findByUserIdAndDate(UUID userId, Date date);

    Optional<WeightLog> findFirstByUserIdOrderByDateDesc(UUID userId);
}
