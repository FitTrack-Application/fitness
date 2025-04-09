package com.hcmus.fitservice.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.UuidGenerator;

import java.util.Date;
import java.util.List;
import java.util.UUID;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "meal_logs")
public class MealLog {
    @Id
    @GeneratedValue
    @UuidGenerator
    @Column(name = "meal_log_id")
    private UUID mealLogId;

    @Temporal(TemporalType.DATE)
    @Column(nullable = false)
    private Date date;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private MealType mealType;

    @Column(nullable = false)
    private UUID userId;

    @OneToMany(mappedBy = "mealLog", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<MealEntry> mealEntries;
}
