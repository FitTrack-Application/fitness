package com.hcmus.foodservice.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
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
@Table(name = "recipe_entries")
public class RecipeEntry {

    @Id
    @GeneratedValue
    @UuidGenerator
    @Column(name = "recipe_entry_id")
    private UUID recipeEntryId;

    @ManyToOne
    @JoinColumn(name = "recipe_id", referencedColumnName = "recipe_id", nullable = false)
    private Recipe recipe;

    @ManyToOne
    @JoinColumn(name = "food_id", referencedColumnName = "food_id", nullable = false)
    private Food food;

    @NotNull
    @Column(name = "number_of_servings", nullable = false)
    private Double numberOfServings;

    @ManyToOne
    @JoinColumn(name = "serving_unit", referencedColumnName = "serving_unit_id", nullable = false)
    private ServingUnit servingUnit;
}
