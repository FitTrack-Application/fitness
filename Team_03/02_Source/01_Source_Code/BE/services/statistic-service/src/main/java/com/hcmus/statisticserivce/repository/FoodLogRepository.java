package com.hcmus.statisticserivce.repository;

import com.hcmus.statisticserivce.model.FoodLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@Repository
public interface FoodLogRepository extends JpaRepository<FoodLog, UUID> {
    List<FoodLog> findByUserId(UUID userId);

    List<FoodLog> findByUserIdAndDate(UUID userId, LocalDate date);

    List<FoodLog> findByUserIdAndDateBetween(UUID userId, LocalDate startDate, LocalDate endDate);

    List<FoodLog> findByFoodItem(String foodItem);
}