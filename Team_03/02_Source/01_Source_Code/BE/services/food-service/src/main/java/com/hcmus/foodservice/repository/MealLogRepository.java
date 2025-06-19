package com.hcmus.foodservice.repository;

import com.hcmus.foodservice.model.MealLog;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Date;
import java.util.List;
import java.util.UUID;

public interface MealLogRepository extends JpaRepository<MealLog, UUID> {

    List<MealLog> findByUserIdAndDate(UUID userId, Date date);
}
