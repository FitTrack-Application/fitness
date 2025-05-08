package com.hcmus.statisticservice.domain.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.*;
import org.hibernate.annotations.UuidGenerator;

import java.util.Date;
import java.util.UUID;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "step_logs")
public class StepLog {
    @Id
    @GeneratedValue
    @UuidGenerator
    @Column(name = "step_log_id", nullable = false)
    private UUID stepLogId;

    @NotNull
    @Temporal(TemporalType.DATE)
    @Column(name = "date", nullable = false)
    private Date date;

    @NotNull
    @Column(name = "step_count", nullable = false)
    private Integer stepCount;

    @NotNull
    @Column(name = "user_id", nullable = false)
    private UUID userId;
}