package com.hcmus.statisticservice.infrastructure.repository;

import com.hcmus.statisticservice.domain.model.LatestLogin;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface JpaLatestLoginRepository extends JpaRepository<LatestLogin, UUID> {
    LatestLogin findByUserId(UUID userId);

    void deleteById(UUID id);

    boolean existsByUserId(UUID userId);    
}