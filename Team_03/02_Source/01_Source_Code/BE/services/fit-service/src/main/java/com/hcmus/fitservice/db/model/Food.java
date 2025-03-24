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
@Table(name = "foods")
public class Food {

    @Id
    @GeneratedValue
    @UuidGenerator
    @Column(name = "foodid", updatable = false, nullable = false)
    private UUID foodId;

    @NotNull
    @Size(max = 255)
    @Column(nullable = false)
    private String foodName;

    @NotNull
    @Column(nullable = false)
    private Double calories;

    private Double protein;

    private Double carbs;

    private Double fat;
}