package com.hcmus.foodservice.repository;

import com.hcmus.foodservice.model.MealLog;
import com.hcmus.foodservice.model.type.MealType;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;

import java.util.*;

import static org.assertj.core.api.Assertions.assertThat;

@DataJpaTest
public class MealLogRepositoryTests {

    @Autowired
    private MealLogRepository mealLogRepository;

    private MealLog createMealLog(UUID userId, Date date, MealType mealType) {
        MealLog log = new MealLog();
        log.setUserId(userId);
        log.setDate(date);
        log.setMealType(mealType);
        return mealLogRepository.save(log);
    }

    @Test
    void MealLogRepository_findByUserIdAndDate_ReturnsCorrectMealLogs() {
        UUID userId = UUID.randomUUID();
        Date today = new GregorianCalendar(2024, Calendar.JANUARY, 15).getTime();
        Date otherDay = new GregorianCalendar(2024, Calendar.JANUARY, 16).getTime();

        MealLog log1 = createMealLog(userId, today, MealType.BREAKFAST);
        MealLog log2 = createMealLog(userId, today, MealType.LUNCH);
        MealLog log3 = createMealLog(UUID.randomUUID(), today, MealType.DINNER);
        MealLog log4 = createMealLog(userId, otherDay, MealType.SNACK);

        List<MealLog> result = mealLogRepository.findByUserIdAndDate(userId, today);

        assertThat(result).hasSize(2);
        assertThat(result).extracting(MealLog::getMealType)
                .containsExactlyInAnyOrder(MealType.BREAKFAST, MealType.LUNCH);
    }
}
