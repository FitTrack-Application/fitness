package com.hcmus.userservice.service;

import com.hcmus.userservice.dto.response.UserProfileResponse;
import com.hcmus.userservice.dto.request.UpdateProfileRequest;
import com.hcmus.userservice.dto.response.ApiResponse;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
public interface UserService {

    ApiResponse<UserProfileResponse> getUserProfileResponse(UUID userId);

    ApiResponse<?> getUpdateProfileResponse(UpdateProfileRequest updateProfileRequest, UUID userId);
}
