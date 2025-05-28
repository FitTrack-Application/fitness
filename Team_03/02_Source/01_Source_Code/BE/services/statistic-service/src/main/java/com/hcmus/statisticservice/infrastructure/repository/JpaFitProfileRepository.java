package com.hcmus.statisticservice.infrastructure.repository;

import com.hcmus.statisticservice.domain.model.FitProfile;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;
import java.util.List;

@Repository
public interface JpaFitProfileRepository extends JpaRepository<FitProfile, UUID> {
    Optional<FitProfile> findByUserId(UUID userId);

    boolean existsByUserId(UUID userId);

    @Query(value = """
    SELECT 
        EXTRACT(YEAR FROM created_at) AS year,
        EXTRACT(WEEK FROM created_at) AS week,
        COUNT(*) AS count
    FROM fit_profiles
    WHERE created_at >= CURRENT_DATE - INTERVAL '12 weeks'
    GROUP BY year, week
    ORDER BY year DESC, week DESC
    """, nativeQuery = true)
    List<Object[]> countNewUsersByWeek();


    @Query(value = """
    SELECT 
        EXTRACT(YEAR FROM f.created_at) AS year,
        EXTRACT(WEEK FROM f.created_at) AS week,
        COUNT(*) AS count
    FROM fit_profiles f
    JOIN latest_logins l ON f.user_id = l.user_id
    WHERE f.created_at >= CURRENT_DATE - INTERVAL '14 weeks'
      AND f.created_at < CURRENT_DATE - INTERVAL '2 weeks'
      AND l.date - f.created_at < 5
    GROUP BY year, week
    ORDER BY year DESC, week DESC
    """, nativeQuery = true)
    List<Object[]> countEarlyChurnByWeek();


}