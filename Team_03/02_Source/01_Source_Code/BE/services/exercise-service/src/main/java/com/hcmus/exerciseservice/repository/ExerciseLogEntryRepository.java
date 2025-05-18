package com.hcmus.exerciseservice.repository;

import com.hcmus.exerciseservice.model.ExerciseLogEntry;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.domain.Pageable;

import java.util.List;
import java.util.UUID;

public interface ExerciseLogEntryRepository extends JpaRepository<ExerciseLogEntry, UUID> {
    @Query("SELECT COUNT(DISTINCT ex.exercise.exerciseId) FROM ExerciseLogEntry ex")
    Integer countDistinctExerciseUsed();

    @Query("SELECT DISTINCT ex.exercise.exerciseId FROM ExerciseLogEntry ex")
    List<UUID> findDistinctExerciseIdsUsed();

    @Query("SELECT ex.exercise.exerciseId FROM ExerciseLogEntry ex GROUP BY ex.exercise.exerciseId ORDER BY COUNT(ex.exercise.exerciseId) DESC")
    List<UUID> findTopMostUsedExerciseIds(Pageable pageable);

    Integer countByExercise_ExerciseId(UUID exerciseId);
}
