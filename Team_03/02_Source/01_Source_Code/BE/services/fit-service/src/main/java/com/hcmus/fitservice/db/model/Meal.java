package com.hcmus.fitservice.db.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.UuidGenerator;

import java.util.UUID;

@Getter
@Setter
@Entity
@Table(name = "meals")
public class Meal {

    @Id
    @GeneratedValue
    @UuidGenerator
    @Column(name = "mealid", updatable = false, nullable = false)
    private UUID mealId;

    @NotNull
    @Size(max = 255)
    @Column(nullable = false)
    private String foodName;

    @NotNull
    @Column(nullable = false)
    private Double calories;

    @Size(max = 50)
    private String unit;

    private Double protein;

    private Double carbs;

    private Double fat;
}