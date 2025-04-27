package com.hcmus.statisticservice.repository;

import com.hcmus.statisticservice.model.FitProfile;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface FitProfileRepository extends JpaRepository<FitProfile, UUID> {

    Boolean existsByUserId(UUID userId);

    Optional<FitProfile> findByUserId(UUID userId);
}