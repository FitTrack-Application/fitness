package com.hcmus.userservice.service;

import com.hcmus.userservice.dto.UserDto;
import com.hcmus.userservice.dto.request.UpdateProfileRequest;
import com.hcmus.userservice.dto.response.ApiResponse;
import com.hcmus.userservice.dto.response.GoalResponse;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
public interface UserService {

    ApiResponse<UserDto> getUserProfileResponse(UUID userId);

    ApiResponse<?> getUpdateProfileResponse(UpdateProfileRequest updateProfileRequest, UUID userId);
}
