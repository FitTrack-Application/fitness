package com.hcmus.fitservice.db.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.UuidGenerator;

import java.util.UUID;

@Getter
@Setter
@Entity
@Table(name = "trainingfacilities")
public class TrainingFacility {

    @Id
    @GeneratedValue
    @UuidGenerator
    @Column(name = "facilityid", updatable = false, nullable = false)
    private UUID facilityId;

    @NotNull
    @Size(max = 255)
    @Column(nullable = false)
    private String name;

    @NotNull
    @Column(nullable = false)
    private String address;

    @Column(columnDefinition = "text[]")
    private String[] availableServices;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "brandid")
    private Brand brand;
}