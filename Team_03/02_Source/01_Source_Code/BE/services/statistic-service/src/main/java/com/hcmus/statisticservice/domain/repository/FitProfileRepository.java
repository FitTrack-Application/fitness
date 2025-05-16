package com.hcmus.statisticservice.domain.repository;

import com.hcmus.statisticservice.domain.model.FitProfile;

import java.util.Optional;
import java.util.UUID;

public interface FitProfileRepository {
    FitProfile save(FitProfile fitProfile);

    boolean existsByUserId(UUID userId);

    Optional<FitProfile> findByUserId(UUID userId);

    Integer count();

    void deleteById(UUID id);
}