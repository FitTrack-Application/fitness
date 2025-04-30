package com.hcmus.fitservice.dto.request;

import lombok.*;

import java.util.Date;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class MealLogRequest {

    private Date date;

    private String mealType;
}
