package com.hcmus.exerciseservice.repository;

import com.hcmus.exerciseservice.model.ExerciseLogEntry;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface ExerciseLogEntryRepository extends JpaRepository<ExerciseLogEntry, UUID> {
}
