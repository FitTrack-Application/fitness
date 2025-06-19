package com.hcmus.foodservice.model;

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
@Table(name = "serving_units")
public class ServingUnit {

    @Id
    @GeneratedValue
    @UuidGenerator
    @Column(name = "serving_unit_id")
    private UUID servingUnitId;

    @NotNull
    @Column(name = "unit_name", unique = true, nullable = false)
    private String unitName;

    @NotNull
    @Column(name = "unit_symbol", unique = true, nullable = false)
    private String unitSymbol;

    @NotNull
    @Column(name = "conversion_to_grams", nullable = false)
    private Double conversionToGrams;
}
