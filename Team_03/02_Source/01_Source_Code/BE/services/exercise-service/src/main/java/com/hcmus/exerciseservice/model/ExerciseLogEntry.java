package com.hcmus.exerciseservice.model;


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
@Table(name = "exercise_log_entries")
public class ExerciseLogEntry {

    @Id
    @GeneratedValue
    @UuidGenerator
    @Column(name = "exercise_log_entry_id")
    private UUID exerciseLogEntryId;

    @ManyToOne
    @JoinColumn(name = "exercise_log_id", referencedColumnName = "exercise_log_id", nullable = false)
    private ExerciseLog exerciseLog;

    @ManyToOne
    @JoinColumn(name = "exercise_id", referencedColumnName = "exercise_id", nullable = false)
    private Exercise exercise;

    @NotNull
    @Column(name = "duration", nullable = false)
    private Integer duration; // In minutes
}
