package com.hcmus.statisticserivce.db.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.UuidGenerator;

import java.time.LocalDate;
import java.util.UUID;

@Getter
@Setter
@Entity
@Table(name = "traininglogs")
public class TrainingLog {

    @Id
    @GeneratedValue
    @UuidGenerator
    @Column(name = "logid", updatable = false, nullable = false)
    private UUID logId;

    @NotNull
    @Column(name = "userid", nullable = false)
    private UUID userId;

    @Column(name = "excerciseid")
    private UUID excerciseId;

    @NotNull
    @Column(nullable = false)
    private LocalDate date;

    @NotNull
    @Column(nullable = false)
    private Integer duration;

    private Double caloriesBurned;
}