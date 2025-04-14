package com.hcmus.userservice.service;

import com.hcmus.userservice.dto.request.UpdateProfileRequest;
import com.hcmus.userservice.dto.response.ApiResponse;
import com.hcmus.userservice.dto.response.UserProfileResponse;
import com.hcmus.userservice.exception.UserNotFoundException;
import com.hcmus.userservice.mapper.UserMapper;
import com.hcmus.userservice.model.User;
import com.hcmus.userservice.model.type.Gender;
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

    private final UserMapper userMapper;

    @Override
    public ApiResponse<UserProfileResponse> getUserProfileResponse(UUID userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new UserNotFoundException("The user is not found!"));

        UserProfileResponse userProfileResponse = userMapper.convertToUserDto(user);

        return ApiResponse.<UserProfileResponse>builder()
                .status(HttpStatus.OK.value())
                .generalMessage("Get profile successfully!")
                .data(userProfileResponse)
                .timestamp(LocalDateTime.now())
                .build();
    }

    public ApiResponse<?> getUpdateProfileResponse(UpdateProfileRequest updateProfileRequest, UUID userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new UserNotFoundException("The user is not found!"));

        user.setName(updateProfileRequest.getName() == null ? user.getName() : updateProfileRequest.getName());
        user.setAge(updateProfileRequest.getAge() == null ? user.getAge() : updateProfileRequest.getAge());
        if (updateProfileRequest.getGender() != null) {
            Gender gender = Gender.fromString(updateProfileRequest.getGender());
            user.setGender(gender);
        }
        user.setHeight(updateProfileRequest.getHeight() == null ? user.getHeight() : updateProfileRequest.getHeight());
        user.setWeight(updateProfileRequest.getWeight() == null ? user.getWeight() : updateProfileRequest.getWeight());
        user.setImageUrl(updateProfileRequest.getImageUrl() == null ? user.getImageUrl() : updateProfileRequest.getImageUrl());

        userRepository.save(user);

        return ApiResponse.builder()
                .status(HttpStatus.OK.value())
                .generalMessage("Update profile successfully for " + user.getName() + "!")
                .timestamp(LocalDateTime.now())
                .build();
    }
}
