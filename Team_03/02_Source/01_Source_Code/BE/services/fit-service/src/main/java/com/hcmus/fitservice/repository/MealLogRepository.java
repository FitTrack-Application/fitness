package com.hcmus.fitservice.repository;

import com.hcmus.fitservice.model.MealLog;
import com.hcmus.fitservice.model.type.MealType;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Date;
import java.util.List;
import java.util.UUID;

public interface MealLogRepository extends JpaRepository<MealLog, UUID> {

    List<MealLog> findByUserIdAndDate(UUID userId, Date date);
}
