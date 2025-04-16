package com.hcmus.statisticservice.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.*;

import java.util.Date;
import java.util.UUID;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "weight_logs")
public class WeightLog {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @Column(name = "weight_log_id", nullable = false)
    private UUID weightLogId;

    @NotNull
    @Temporal(TemporalType.DATE)
    @Column(name = "date", nullable = false)
    private Date date;

    @NotNull
    @Column(name = "weight", nullable = false)
    private Double weight;

    @Column(name = "image_url", length = Integer.MAX_VALUE)
    private String imageUrl;

    @NotNull
    @Column(name = "user_id", nullable = false)
    private UUID userId;

}