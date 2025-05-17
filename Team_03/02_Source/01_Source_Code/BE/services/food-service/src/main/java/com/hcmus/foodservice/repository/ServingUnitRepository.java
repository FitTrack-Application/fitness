package com.hcmus.foodservice.repository;

import com.hcmus.foodservice.model.ServingUnit;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface ServingUnitRepository extends JpaRepository<ServingUnit, UUID> {
}
