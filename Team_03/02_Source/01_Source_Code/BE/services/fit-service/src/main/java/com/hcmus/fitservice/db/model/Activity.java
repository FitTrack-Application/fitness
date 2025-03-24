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
@Table(name = "activities")
public class Activity {

    @Id
    @GeneratedValue
    @UuidGenerator
    @Column(name = "activityid", updatable = false, nullable = false)
    private UUID activityId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "userid", nullable = false)
    private User user;

    @NotNull
    @Size(max = 100)
    @Column(nullable = false)
    private String type;

    @NotNull
    @Column(nullable = false)
    private Integer duration;

    private Double distance;

    private Double caloriesBurned;

    @NotNull
    @Column(nullable = false)
    private LocalDate date;
}