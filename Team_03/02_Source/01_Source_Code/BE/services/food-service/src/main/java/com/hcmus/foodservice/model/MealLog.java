package com.hcmus.foodservice.model;

import com.hcmus.foodservice.model.type.MealType;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import org.hibernate.annotations.UuidGenerator;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;
import java.util.UUID;

@Getter
@Setter
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
    @Column(name = "date", nullable = false)
    private Date date;

    @Enumerated(EnumType.STRING)
    @Column(name = "meal_type", nullable = false)
    private MealType mealType;

    @NotNull
    @Column(name = "user_id", nullable = false)
    private UUID userId;

    @OneToMany(mappedBy = "mealLog", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<MealEntry> mealEntries;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
}
