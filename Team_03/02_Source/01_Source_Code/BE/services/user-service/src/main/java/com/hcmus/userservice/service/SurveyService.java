package com.hcmus.userservice.service;

import com.hcmus.userservice.dto.request.SurveyRequest;
import com.hcmus.userservice.dto.response.ApiResponse;
import com.hcmus.userservice.dto.response.SurveyResponse;
import com.hcmus.userservice.model.Goal;
import com.hcmus.userservice.model.Role;
import com.hcmus.userservice.model.User;
import com.hcmus.userservice.repository.UserRepository;
import com.hcmus.userservice.repository.GoalRepository;
import lombok.RequiredArgsConstructor;


import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.UUID;

import org.springframework.http.HttpStatus;
import org.springframework.web.server.ResponseStatusException;

@Service
@RequiredArgsConstructor
public class SurveyService {

    private final UserRepository userRepository;
    private final GoalRepository goalRepository;

    private final PasswordEncoder passwordEncoder;

    public ApiResponse<SurveyResponse> survey(SurveyRequest request, UUID userId) {
        User user = userRepository.findById(userId).orElse(null);
        if (user == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid information. returPlease try again");
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
        goal.setStartingDate(LocalDate.now());

        goalRepository.save(goal);

        return ApiResponse.<SurveyResponse>builder()
                .status(HttpStatus.OK.value())
                .generalMessage("success")
                .data(buildSurveyResponse(user, goal))
                .build();
        
    }

    private SurveyResponse buildSurveyResponse(User user, Goal goal) {
        return SurveyResponse.builder()
                .userId(user.getUserId())
                .goalId(goal.getGoalId())
                .message("Successfully get user information and create goal")
                .build();

    }
}
