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
@Table(name = "foodlogs")
public class FoodLog {

    @Id
    @GeneratedValue
    @UuidGenerator
    @Column(name = "foodlogid", updatable = false, nullable = false)
    private UUID foodLogId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "userid", nullable = false)
    private User user;

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