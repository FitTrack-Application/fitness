package com.hcmus.statisticservice.infrastructure.repository;

import com.hcmus.statisticservice.domain.model.LatestLogin;
import com.hcmus.statisticservice.domain.repository.LatestLoginRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.Optional;
import java.util.UUID;

@Component
@RequiredArgsConstructor
public class LatestLoginRepositoryAdapter {
    
    private final JpaLatestLoginRepository jpaLatestLoginRepository;

    public LatestLogin save(LatestLogin latestLogin) {
        return jpaLatestLoginRepository.save(latestLogin);
    }

    public boolean existsByUserId(UUID userId) {
        return jpaLatestLoginRepository.existsByUserId(userId);
    }

    public Optional<LatestLogin> findByUserId(UUID userId) {
        return jpaLatestLoginRepository.findByUserId(userId);
    }

    public void deleteById(UUID id) {
        jpaLatestLoginRepository.deleteById(id);
    }
}
