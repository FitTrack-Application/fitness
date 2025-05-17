package com.hcmus.foodservice.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.UuidGenerator;

import java.util.UUID;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "foods")
public class Food {

    @Id
    @GeneratedValue
    @UuidGenerator
    @Column(name = "food_id")
    private UUID foodId;

    @Size(max = 255)
    @NotNull
    @Column(name = "food_name", nullable = false)
    private String foodName;

    @NotNull
    @Column(name = "calories_per_100g", nullable = false)
    private Integer caloriesPer100g;

    @NotNull
    @Column(name = "protein_per_100g", nullable = false)
    private Double proteinPer100g;

    @NotNull
    @Column(name = "carbs_per_100g", nullable = false)
    private Double carbsPer100g;

    @NotNull
    @Column(name = "fat_per_100g", nullable = false)
    private Double fatPer100g;

    @Size(max = 255)
    @Column(name = "image_url")
    private String imageUrl;

    @Column(name = "user_id")
    private UUID userId;
}
