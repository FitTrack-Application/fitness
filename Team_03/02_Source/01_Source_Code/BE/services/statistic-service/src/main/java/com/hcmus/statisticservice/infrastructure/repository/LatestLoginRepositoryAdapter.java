package com.hcmus.statisticservice.infrastructure.repository;

import com.hcmus.statisticservice.domain.model.LatestLogin;
import com.hcmus.statisticservice.domain.repository.LatestLoginRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.util.UUID;

@Component
@RequiredArgsConstructor
public class LatestLoginRepositoryAdapter implements LatestLoginRepository {
    
    private final JpaLatestLoginRepository jpaLatestLoginRepository;

    public LatestLogin save(LatestLogin latestLogin) {
        return jpaLatestLoginRepository.save(latestLogin);
    }

    public boolean existsByUserId(UUID userId) {
        return jpaLatestLoginRepository.existsByUserId(userId);
    }

    public LatestLogin findByUserId(UUID userId) {
        return jpaLatestLoginRepository.findByUserId(userId);
    }

    public Integer countActiveUser() {
        LocalDate twoWeeksAgo = LocalDate.now().minusWeeks(2);
        return jpaLatestLoginRepository.countActiveUsersLastTwoWeeks(twoWeeksAgo);
    }

    public void deleteById(UUID id) {
        jpaLatestLoginRepository.deleteById(id);
    }
}
