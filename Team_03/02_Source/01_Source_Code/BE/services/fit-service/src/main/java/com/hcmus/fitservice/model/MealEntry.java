package com.hcmus.fitservice.model;


import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.UuidGenerator;

import java.util.UUID;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "meal_entries")
public class MealEntry {
    @Id
    @GeneratedValue
    @UuidGenerator
    @Column(name = "meal_entry_id")
    private UUID mealEntryId;

    @ManyToOne
    @JoinColumn(name = "meal_log_id", referencedColumnName = "meal_log_id", nullable = false)
    private MealLog mealLog;

    @ManyToOne
    @JoinColumn(name = "food_id", referencedColumnName = "food_id", nullable = false)
    private Food food;

    @Column(nullable = false)
    private Integer numberOfServings;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private ServingUnit servingUnit;

}
