package com.hcmus.exerciseservice.repository;

import com.hcmus.exerciseservice.model.Exercise;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface ExerciseRepository extends JpaRepository<Exercise, UUID> {
    Page<Exercise> findByUserIdIsNull(Pageable pageable);

    Page<Exercise> findByUserIdIsNullAndExerciseNameContainingIgnoreCase(String name, Pageable pageable);

    Page<Exercise> findByUserId(UUID userId, Pageable pageable);

    Page<Exercise> findByUserIdAndExerciseNameContainingIgnoreCase(UUID userId, String name, Pageable pageable);

    Optional<Exercise> findByExerciseIdAndUserId(UUID exerciseId, UUID userId);

    Exercise findByExerciseId(UUID exerciseId);

    boolean existsByExerciseIdAndUserIdIsNotNull(UUID exerciseId);
}
