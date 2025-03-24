package com.hcmus.statisticserivce.db.model;

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
@Table(name = "goals")
public class Goal {

    @Id
    @GeneratedValue
    @UuidGenerator
    @Column(name = "goalid", updatable = false, nullable = false)
    private UUID goalId;

    @NotNull
    @Column(name = "userid", nullable = false)
    private UUID userId;

    @NotNull
    @Size(max = 100)
    @Column(nullable = false)
    private String goalType;

    private Double targetValue;

    private Double currentValue;

    private Double progress;

    private LocalDate deadline;

    @Column(columnDefinition = "boolean default false")
    private Boolean achievedStatus = false;
}