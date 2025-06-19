package com.hcmus.statisticservice.domain.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.*;

import java.util.Date;
import java.util.UUID;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "weight_goals")
public class WeightGoal {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @Column(name = "weight_goal_id", nullable = false)
    private UUID weightGoalId;

    @NotNull
    @Column(name = "starting_weight", nullable = false)
    private Double startingWeight;

    @NotNull
    @Temporal(TemporalType.DATE)
    @Column(name = "starting_date", nullable = false)
    private Date startingDate;

    @NotNull
    @Column(name = "goal_weight", nullable = false)
    private Double goalWeight;

    @NotNull
    @Column(name = "weekly_goal", nullable = false)
    private Double weeklyGoal;

    @NotNull
    @Column(name = "user_id", nullable = false)
    private UUID userId;
}