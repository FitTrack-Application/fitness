package com.hcmus.fitservice.db.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.UuidGenerator;

import java.util.List;
import java.util.UUID;

@Getter
@Setter
@Entity
@Table(name = "brands")
public class Brand {

    @Id
    @GeneratedValue
    @UuidGenerator
    @Column(name = "brandid", updatable = false, nullable = false)
    private UUID brandId;

    @NotNull
    @Size(max = 255)
    @Column(nullable = false)
    private String name;

    @Column(columnDefinition = "text[]")
    private String[] services;

    @Column(columnDefinition = "boolean default false")
    private Boolean approvedStatus = false;

    @OneToMany(mappedBy = "brand")
    private List<TrainingFacility> facilities;
}