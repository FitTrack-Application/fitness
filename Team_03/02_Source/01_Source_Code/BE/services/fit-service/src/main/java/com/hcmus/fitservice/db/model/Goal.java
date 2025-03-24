package com.hcmus.fitservice.db.model;

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

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "userid", nullable = false)
    private User user;

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