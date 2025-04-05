package com.hcmus.userservice.service;

import com.hcmus.userservice.model.User;
import com.hcmus.userservice.dto.request.UserUpdateRequest;
import com.hcmus.userservice.dto.response.ApiResponse;
import com.hcmus.userservice.exception.UserNotFoundException;
import com.hcmus.userservice.repository.UserRepository;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;


import java.util.UUID;
import java.time.LocalDateTime;

@Service 
public class UpdateInforUserService {
    private final UserRepository userRepository;

    public UpdateInforUserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public ApiResponse<String> updateUserProfile(UserUpdateRequest userUpdateRequest, UUID userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new UserNotFoundException("Không tìm thấy người dùng"));

        user.setName(userUpdateRequest.getName());
        user.setAge(userUpdateRequest.getAge());
        user.setGender(userUpdateRequest.getGender());
        user.setHeight(userUpdateRequest.getHeight());
        user.setWeight(userUpdateRequest.getWeight());
        user.setImageUrl(userUpdateRequest.getImageUrl());

        userRepository.save(user);

        return ApiResponse.<String>builder()
                .status(HttpStatus.OK.value())
                .generalMessage("Cập nhật thông tin người dùng thành công")
                .data("Cập nhật thông tin người dùng thành công cho người dùng có ID: " + userId)
                .timestamp(LocalDateTime.now())
                .build();
    }
}
