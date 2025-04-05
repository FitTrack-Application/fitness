package com.hcmus.fitservice.model;

import jakarta.persistence.*;
<<<<<<< HEAD
import lombok.AllArgsConstructor;
=======
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Cleanup;
>>>>>>> origin/Tu
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.UuidGenerator;

import java.util.UUID;

<<<<<<< HEAD
@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
=======
@Data
@AllArgsConstructor
@NoArgsConstructor
@Entity
>>>>>>> origin/Tu
@Table(name = "foods")
public class Food {
    @Id
    @GeneratedValue
    @UuidGenerator
    @Column(name = "food_id")
<<<<<<< HEAD
    private UUID id;

    private String name;

    @Column(name = "calories_per_100g")
    private int caloriesPer100g;

    @Column(name = "protein_per_100g")
    private double proteinPer100g;

    @Column(name = "carbs_per_100g")
    private double carbsPer100g;

    @Column(name = "fat_per_100g")
    private double fatPer100g;

    private String imageUrl;

=======
    private UUID foodId;

    @NotNull(message = "Food name cannot be null")
    @Column(nullable = false)
    private String foodName;

    @NotNull(message = "Calories cannot be null")
    @Column(name = "calories_per_100g", nullable = false)
    private Integer caloriesPer100g;

    @NotNull(message = "Protein cannot be null")
    @Column(name = "protein_per_100g", nullable = false)
    private Double proteinPer100g;

    @NotNull(message = "Carbs cannot be null")
    @Column(name = "carbs_per_100g", nullable = false)
    private Double carbsPer100g;

    @NotNull(message = "Fat cannot be null")
    @Column(name = "fat_per_100g", nullable = false)
    private Double fatPer100g;

    @NotNull(message = "Image url cannot be null")
    @Column(nullable = false)
    private String imageUrl;

    private UUID userId;
>>>>>>> origin/Tu
}
