package com.hcmus.fitservice.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.UuidGenerator;

import java.util.UUID;


@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "foods")
public class Food {
    @Id
    @GeneratedValue
    @UuidGenerator
    @Column(name="food_id")
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

}
