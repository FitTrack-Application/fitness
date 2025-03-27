package com.hcmus.userservice.service;

import com.hcmus.userservice.dto.SurveyResponse;
import com.hcmus.userservice.dto.DataResponse;
import com.hcmus.userservice.dto.SurveyRequest;
import com.hcmus.userservice.model.Goal;
import com.hcmus.userservice.model.Role;
import com.hcmus.userservice.model.User;
import com.hcmus.userservice.repository.UserRepository;
import com.hcmus.userservice.repository.GoalRepository;
import lombok.RequiredArgsConstructor;


import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.http.HttpStatus;
import org.springframework.web.server.ResponseStatusException;

@Service
@RequiredArgsConstructor
public class SurveyService {

    private final UserRepository userRepository;
    private final GoalRepository goalRepository;

    private final PasswordEncoder passwordEncoder;

    public SurveyResponse survey(SurveyRequest request) {
        if (userRepository.existsByEmail(request.getEmail())) {
            return buildSurveyResponse("error", "Invalid information. Please try again");
        }

        User user = new User();
        user.setName(request.getName());
        user.setEmail(request.getEmail());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setAge(request.getAge());
        user.setGender(request.getGender());
        user.setHeight(request.getHeight());
        user.setWeight(request.getWeight());
        user.setImageUrl(request.getImageUrl());

        // Nếu role không được chỉ định, mặc định là USER
        user.setRole(request.getRole() != null ? request.getRole() : Role.USER);

        userRepository.save(user);

        Goal goal = new Goal();
        goal.setUser(user);
        goal.setGoalType(request.getGoalType());
        goal.setTarget(request.getTarget());
        goal.setGoalPerWeek(request.getGoalPerWeek());
        goal.setStartingDay(request.getStartingDay());

        goalRepository.save(goal);
        return buildSurveyResponse("success", new DataResponse(goal.getGoalId(), "Information is successfully saved"));
    }

    private SurveyResponse buildSurveyResponse(String status, Object data) {
        return SurveyResponse.builder()
                .status(status)
                .data(data)
                .build();

    }
}
