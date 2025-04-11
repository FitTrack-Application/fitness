package com.hcmus.fitservice.dto.request;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;
import java.util.UUID;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class MealLogRequest {
    private UUID userId; // Sẽ bỏ đi và lấy từ JWT

    private Date date;

    private String mealType;
}
