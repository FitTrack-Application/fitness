package com.hcmus.fitservice.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.UuidGenerator;

import java.util.UUID;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "foods")
public class Food {
    @Id
    @GeneratedValue
    @UuidGenerator
    private UUID foodId;

    @NotNull(message = "Food name cannot be null")
    @Column(nullable = false)
    private String foodName;

    @NotNull(message = "Calories cannot be null")
    @Column(nullable = false)
    private Integer caloriesPer100g;

    @NotNull(message = "Protein cannot be null")
    @Column(nullable = false)
    private Double proteinPer100g;

    @NotNull(message = "Carbs cannot be null")
    @Column(nullable = false)
    private Double carbsPer100g;

    @NotNull(message = "Fat cannot be null")
    @Column(nullable = false)
    private Double fatPer100g;

    @NotNull(message = "Image url cannot be null")
    @Column(nullable = false)
    private String imageUrl;

    private UUID userId;
}
