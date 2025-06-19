package com.hcmus.exerciseservice.model;


import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.UuidGenerator;

import java.util.Date;
import java.util.List;
import java.util.UUID;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "exercise_logs")
public class ExerciseLog {

    @Id
    @GeneratedValue
    @UuidGenerator
    @Column(name = "exercise_log_id")
    private UUID exerciseLogId;

    @Temporal(TemporalType.DATE)
    @Column(name = "date", nullable = false)
    private Date date;

    @NotNull
    @Column(name = "user_id", nullable = false)
    private UUID userId;

    @OneToMany(mappedBy = "exerciseLog", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<ExerciseLogEntry> exerciseLogEntries;

}
