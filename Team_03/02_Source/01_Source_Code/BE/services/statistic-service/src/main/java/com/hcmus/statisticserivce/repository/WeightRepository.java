package com.hcmus.statisticserivce.repository;

import com.hcmus.statisticserivce.db.model.WeightProgress;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface WeightRepository extends JpaRepository<WeightProgress, UUID> {
    List<WeightProgress> findByUserId(UUID userId);

    List<WeightProgress> findByGoalId(UUID goalId);

    List<WeightProgress> findByUserIdAndGoalId(UUID userId, UUID goalId);
}
