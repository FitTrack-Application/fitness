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

import java.util.UUID;

import org.springframework.http.HttpStatus;
import org.springframework.web.server.ResponseStatusException;

@Service
@RequiredArgsConstructor
public class SurveyService {

    private final UserRepository userRepository;
    private final GoalRepository goalRepository;

    private final PasswordEncoder passwordEncoder;

    public SurveyResponse survey(SurveyRequest request, UUID userId) {
        User user = userRepository.findById(userId).orElse(null);
        if (user == null) {
            return buildSurveyResponse("error", "Invalid information. Please try again");
        }
        
        user.setName(request.getName());
        user.setAge(request.getAge());
        user.setGender(request.getGender());
        user.setHeight(request.getHeight());
        user.setWeight(request.getWeight());
        user.setImageUrl(request.getImageUrl());


        userRepository.save(user);

        Goal goal = new Goal();
        goal.setUser(user);
        goal.setGoalType(request.getGoalType());
        goal.setWeightGoal(request.getWeightGoal());
        goal.setGoalPerWeek(request.getGoalPerWeek());
        goal.setActivityLevel(request.getActivityLevel());
        goal.setCaloriesGoal(request.getCaloriesGoal());

        goalRepository.save(goal);
        return buildSurveyResponse("success", new DataResponse(user.getUserId(), goal.getGoalId(), "Successfully get user information and create goal"));
    }

    private SurveyResponse buildSurveyResponse(String status, Object data) {
        return SurveyResponse.builder()
                .status(status)
                .data(data)
                .build();

    }
}
