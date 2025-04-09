package com.hcmus.userservice.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.UuidGenerator;
import java.time.LocalDate;

import java.util.UUID;

@Getter
@Setter
@Entity
@Table(name = "goals")
public class Goal {

    @Id
    @GeneratedValue
    @UuidGenerator
    @Column(name = "goalid", updatable = false, nullable = false)
    private UUID goalId;

    @OneToOne
    @JoinColumn(name = "user_id", nullable = false, unique = true)
    private User user;

    private String goalType;
    private Double weightGoal;
    private Double goalPerWeek;
    private String activityLevel;
    private Double caloriesGoal;
    private LocalDate startingDate;
}
