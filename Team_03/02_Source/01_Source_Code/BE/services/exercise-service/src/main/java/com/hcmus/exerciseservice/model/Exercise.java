package com.hcmus.exerciseservice.model;


import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.UuidGenerator;

import java.util.UUID;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "exercises")
public class Exercise {

    @Id
    @GeneratedValue
    @UuidGenerator
    @Column(name = "exercise_id")
    private UUID exerciseId;

    @NotNull
    @Column(name = "exercise_name", nullable = false)
    private String exerciseName;

    @NotNull
    @Column(name = "calories_burned_per_minute", nullable = false)
    private Integer caloriesBurnedPerMinute;

    @Column(name = "user_id")
    private UUID userId;

}
