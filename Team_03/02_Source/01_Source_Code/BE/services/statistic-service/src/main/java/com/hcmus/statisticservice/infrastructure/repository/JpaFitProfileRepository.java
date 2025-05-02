package com.hcmus.statisticservice.infrastructure.repository;

import com.hcmus.statisticservice.domain.model.FitProfile;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface JpaFitProfileRepository extends JpaRepository<FitProfile, UUID> {
    Optional<FitProfile> findByUserId(UUID userId);

    boolean existsByUserId(UUID userId);
}