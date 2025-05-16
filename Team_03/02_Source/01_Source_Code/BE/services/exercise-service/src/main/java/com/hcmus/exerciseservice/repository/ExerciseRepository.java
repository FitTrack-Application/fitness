package com.hcmus.exerciseservice.repository;

import com.hcmus.exerciseservice.model.Exercise;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface ExerciseRepository extends JpaRepository<Exercise, UUID> {
    Page<Exercise> findByExerciseNameContainingIgnoreCase(String name, Pageable pageable);

    Exercise findByExerciseId(UUID exerciseId);

    boolean existsByExerciseIdAndUserIdIsNotNull(UUID exerciseId);
}
