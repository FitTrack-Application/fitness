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
@Table(name = "exercises")
public class Exercise {

    @Id
    @GeneratedValue
    @UuidGenerator
    @Column(name = "exerciseid", updatable = false, nullable = false)
    private UUID exerciseId;

    @NotNull
    @Size(max = 255)
    @Column(nullable = false)
    private String name;

    private String description;

    private Double caloriesBurned;

    private Integer duration;

    @Size(max = 50)
    private String category;
}