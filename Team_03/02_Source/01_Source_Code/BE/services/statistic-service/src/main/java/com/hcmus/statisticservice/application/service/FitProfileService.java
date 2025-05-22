package com.hcmus.statisticservice.application.service;

import com.hcmus.statisticservice.application.dto.request.UpdateProfileRequest;
import com.hcmus.statisticservice.application.dto.response.ApiResponse;
import com.hcmus.statisticservice.application.dto.response.FitProfileResponse;
import com.hcmus.statisticservice.domain.model.FitProfile;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.UUID;

@Service
public interface FitProfileService {
    FitProfile findProfile(UUID userID);

    FitProfile addProfile(UUID userId, FitProfile addProfile);

    FitProfile updateProfile(UUID userId, FitProfile updateProfile);

    ApiResponse<FitProfileResponse> getFindProfileResponse(UUID userID);

    ApiResponse<?> getUpdateProfileResponse(UUID userId, UpdateProfileRequest updateProfileRequest, MultipartFile imageFile);
}