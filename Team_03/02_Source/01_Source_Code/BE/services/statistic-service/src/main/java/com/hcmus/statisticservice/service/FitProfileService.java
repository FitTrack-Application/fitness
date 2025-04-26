package com.hcmus.statisticservice.service;

import com.hcmus.statisticservice.dto.request.UpdateProfileRequest;
import com.hcmus.statisticservice.dto.response.ApiResponse;
import com.hcmus.statisticservice.dto.response.FitProfileResponse;
import com.hcmus.statisticservice.model.FitProfile;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
public interface FitProfileService {

    FitProfile findProfile(UUID userID);

    FitProfile addProfile(UUID userId, FitProfile addProfile);

    FitProfile updateProfile(UUID userId, FitProfile updateProfile);

    ApiResponse<FitProfileResponse> getFindProfileResponse(UUID userID);

    ApiResponse<?> getUpdateProfileResponse(UUID userId, UpdateProfileRequest updateProfileRequest);
}
