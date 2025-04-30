package com.hcmus.fitservice.repository;

import com.hcmus.fitservice.model.ServingUnit;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface ServingUnitRepository extends JpaRepository<ServingUnit, UUID> {
}
