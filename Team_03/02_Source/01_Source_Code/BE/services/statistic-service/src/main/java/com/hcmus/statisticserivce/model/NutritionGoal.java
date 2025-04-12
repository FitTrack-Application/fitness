package com.hcmus.statisticserivce.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

import java.util.UUID;

@Getter
@Setter
@Entity
@Table(name = "nutrition_goals")
public class NutritionGoal {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @Column(name = "nutrition_goal_id", nullable = false)
    private UUID nutritionGoalId;

    @NotNull
    @Column(name = "calories", nullable = false)
    private Integer calories;

    @NotNull
    @Column(name = "protein", nullable = false)
    private Double protein;

    @NotNull
    @Column(name = "carbs", nullable = false)
    private Double carbs;

    @NotNull
    @Column(name = "fat", nullable = false)
    private Double fat;

    @NotNull
    @Column(name = "user_id", nullable = false)
    private UUID userId;

}