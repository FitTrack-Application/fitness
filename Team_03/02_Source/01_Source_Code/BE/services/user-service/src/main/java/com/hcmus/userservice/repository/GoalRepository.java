package com.hcmus.userservice.repository;

import com.hcmus.userservice.model.Goal;

import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

public interface GoalRepository extends JpaRepository<Goal, UUID> {
}

