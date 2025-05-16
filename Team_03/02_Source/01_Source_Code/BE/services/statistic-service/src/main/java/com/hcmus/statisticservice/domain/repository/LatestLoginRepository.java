package com.hcmus.statisticservice.domain.repository;

import com.hcmus.statisticservice.domain.model.LatestLogin;

import java.util.UUID;

public interface LatestLoginRepository {
    LatestLogin save(LatestLogin latestLogin);

    boolean existsByUserId(UUID userId);

    LatestLogin findByUserId(UUID userId);

    Integer countActiveUser();

    void deleteById(UUID id);    
}
