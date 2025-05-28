package com.hcmus.statisticservice.infrastructure.repository;

import com.hcmus.statisticservice.domain.model.FitProfile;
import com.hcmus.statisticservice.domain.repository.FitProfileRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.Optional;
import java.util.UUID;
import java.util.List;

@Component
@RequiredArgsConstructor
public class FitProfileRepositoryAdapter implements FitProfileRepository {

    private final JpaFitProfileRepository jpaFitProfileRepository;

    @Override
    public FitProfile save(FitProfile fitProfile) {
        return jpaFitProfileRepository.save(fitProfile);
    }

    @Override
    public Optional<FitProfile> findByUserId(UUID userId) {
        return jpaFitProfileRepository.findByUserId(userId);
    }

    @Override
    public boolean existsByUserId(UUID userId) {
        return jpaFitProfileRepository.existsByUserId(userId);
    }

    @Override
    public Integer count() {
        return (int) jpaFitProfileRepository.count();
    }

    @Override
    public List<Object[]> countNewUsersByWeek() {
        return jpaFitProfileRepository.countNewUsersByWeek();
    }

    @Override
    public List<Object[]> countEarlyChurnByWeek() {
        return jpaFitProfileRepository.countEarlyChurnByWeek();
    }

    @Override
    public void deleteById(UUID id) {
        jpaFitProfileRepository.deleteById(id);
    }
}