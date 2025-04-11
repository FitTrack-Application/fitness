package com.hcmus.userservice.repository;

import com.hcmus.userservice.model.Goal;
import com.hcmus.userservice.model.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface GoalRepository extends JpaRepository<Goal, UUID> {

    Goal findByUser(User user);
}

