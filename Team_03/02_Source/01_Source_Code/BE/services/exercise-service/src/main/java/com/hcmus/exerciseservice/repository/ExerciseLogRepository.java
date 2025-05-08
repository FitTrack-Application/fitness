package com.hcmus.exerciseservice.repository;

import com.hcmus.exerciseservice.model.ExerciseLog;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Date;
import java.util.UUID;

public interface ExerciseLogRepository extends JpaRepository<ExerciseLog, UUID> {
    boolean existsByUserIdAndDate(UUID userId, Date date);
}
