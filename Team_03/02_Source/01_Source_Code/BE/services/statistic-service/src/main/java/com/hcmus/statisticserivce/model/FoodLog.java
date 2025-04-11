package com.hcmus.statisticserivce.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.UuidGenerator;

import java.time.LocalDate;
import java.util.UUID;

@Getter
@Setter
@Entity
@Table(name = "food_logs")
public class FoodLog {

    @Id
    @GeneratedValue
    @UuidGenerator
    @Column(name = "food_log_id", updatable = false, nullable = false)
    private UUID foodLogId;

    @NotNull
    @Column(name = "user_id", nullable = false)
    private UUID userId;

    @Column(name = "food_id")
    private UUID foodId;

    @NotNull
    @Size(max = 255)
    @Column(nullable = false)
    private String foodItem;

    private Double calories;

    private Double protein;

    private Double carbs;

    private Double fat;

    private Double quantity;

    @NotNull
    @Column(nullable = false)
    private LocalDate date;
}