package com.hcmus.statisticservice.domain.repository;

import com.hcmus.statisticservice.domain.model.LatestLogin;

import java.util.UUID;
import java.util.Optional;

public interface LatestLoginRepository {
    LatestLogin save(LatestLogin latestLogin);

    boolean existsByUserId(UUID userId);

    Optional<LatestLogin> findByUserId(UUID userId);

    void deleteById(UUID id);    
}
