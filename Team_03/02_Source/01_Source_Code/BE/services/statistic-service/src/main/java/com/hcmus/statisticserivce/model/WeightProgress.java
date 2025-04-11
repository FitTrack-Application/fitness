package com.hcmus.statisticserivce.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.UuidGenerator;

import java.time.LocalDate;
import java.util.UUID;

@Getter
@Setter
@Entity
@Table(name = "weightprogress")
public class WeightProgress {

    @Id
    @GeneratedValue
    @UuidGenerator
    @Column(name = "id", updatable = false, nullable = false)
    private UUID id;

    @Column(name = "goalid", nullable = false)
    private UUID goalId;

    @Column(name = "userid", nullable = false)
    private UUID userId;

    @Column(name = "update_date")
    private LocalDate updateDate;

    @Column(name = "weight")
    private Double weight;

    private String progressPhoto;
}
