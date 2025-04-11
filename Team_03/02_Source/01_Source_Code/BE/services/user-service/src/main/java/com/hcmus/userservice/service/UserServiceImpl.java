package com.hcmus.userservice.service;

import com.hcmus.userservice.dto.UserDto;
import com.hcmus.userservice.dto.request.UpdateProfileRequest;
import com.hcmus.userservice.dto.response.ApiResponse;
import com.hcmus.userservice.dto.response.GoalResponse;
import com.hcmus.userservice.exception.UserNotFoundException;
import com.hcmus.userservice.mapper.UserMapper;
import com.hcmus.userservice.model.Goal;
import com.hcmus.userservice.model.User;
import com.hcmus.userservice.repository.GoalRepository;
import com.hcmus.userservice.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.UUID;

@RequiredArgsConstructor
@Service
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;

    private final GoalRepository goalRepository;

    @Override
    public ApiResponse<UserDto> getUserProfileResponse(UUID userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new UserNotFoundException("The user is not found!"));

        UserDto userDto = UserMapper.INSTANCE.convertToUserDto(user);

        return ApiResponse.<UserDto>builder()
                .status(HttpStatus.OK.value())
                .generalMessage("Get profile successfully!")
                .data(userDto)
                .timestamp(LocalDateTime.now())
                .build();
    }

    public ApiResponse<?> getUpdateProfileResponse(UpdateProfileRequest updateProfileRequest, UUID userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new UserNotFoundException("The user is not found!"));

        user.setName(updateProfileRequest.getName());
        user.setAge(updateProfileRequest.getAge());
        user.setGender(updateProfileRequest.getGender());
        user.setHeight(updateProfileRequest.getHeight());
        user.setWeight(updateProfileRequest.getWeight());
        user.setImageUrl(updateProfileRequest.getImageUrl());

        userRepository.save(user);

        return ApiResponse.<String>builder()
                .status(HttpStatus.OK.value())
                .generalMessage("Update profile successfully for " + user.getUserId() + "!")
                .timestamp(LocalDateTime.now())
                .build();
    }

    @Override
    public ApiResponse<GoalResponse> getGoalResponse(UUID userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new UserNotFoundException("Not found user!"));

        Goal goal = goalRepository.findByUser(user);
        GoalResponse goalResponse = new GoalResponse(goal.getGoalId().toString());
        return ApiResponse.<GoalResponse>builder()
                .status(HttpStatus.OK.value())
                .generalMessage("Get goal successfully!")
                .data(goalResponse)
                .timestamp(LocalDateTime.now())
                .build();
    }
}
