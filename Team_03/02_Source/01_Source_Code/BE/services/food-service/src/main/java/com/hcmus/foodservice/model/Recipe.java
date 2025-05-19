package com.hcmus.foodservice.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.UuidGenerator;

import java.util.List;
import java.util.UUID;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "recipes")
public class Recipe {

    @Id
    @GeneratedValue
    @UuidGenerator
    @Column(name = "recipe_id")
    private UUID recipeId;

    @Size(max = 255)
    @NotNull
    @Column(name = "recipe_name", nullable = false)
    private String recipeName;

    @NotNull
    @Column(name = "direction", nullable = false)
    private String direction;

    @NotNull
    @Column(name = "user_id", nullable = false)
    private UUID userId;

    @OneToMany(mappedBy = "recipe", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<RecipeEntry> recipeEntries;
}
