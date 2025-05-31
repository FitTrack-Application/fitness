package com.hcmus.statisticservice.application.service.impl;

import com.hcmus.statisticservice.application.dto.request.UpdateProfileRequest;
import com.hcmus.statisticservice.application.dto.response.ApiResponse;
import com.hcmus.statisticservice.application.dto.response.FitProfileResponse;
import com.hcmus.statisticservice.application.mapper.FitProfileMapper;
import com.hcmus.statisticservice.application.service.FitProfileService;
import com.hcmus.statisticservice.application.service.NutritionGoalService;
import com.hcmus.statisticservice.domain.exception.StatisticException;
import com.hcmus.statisticservice.domain.model.FitProfile;
import com.hcmus.statisticservice.domain.model.type.ActivityLevel;
import com.hcmus.statisticservice.domain.model.type.Gender;
import com.hcmus.statisticservice.domain.repository.FitProfileRepository;
import lombok.RequiredArgsConstructor;
import com.hcmus.statisticservice.infrastructure.client.MediaServiceClient;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.util.Date;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.Map;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class FitProfileServiceImpl implements FitProfileService {

    final private FitProfileRepository fitProfileRepository;
    final private FitProfileMapper fitProfileMapper;
    final private NutritionGoalService nutritionGoalService;
    private final MediaServiceClient mediaServiceClient;

    @Override
    public FitProfile findProfile(UUID userID) {
        return fitProfileRepository.findByUserId(userID).orElseThrow(
                () -> new StatisticException("Fit profile not found!"));
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public FitProfile addProfile(UUID userId, FitProfile addProfile) {
        if (fitProfileRepository.existsByUserId(userId)) {
            throw new StatisticException("Fit profile already exists!");
        }
        FitProfile profile = FitProfile.builder()
                .name(addProfile.getName())
                .age(addProfile.getAge())
                .gender(addProfile.getGender())
                .height(addProfile.getHeight())
                .activityLevel(addProfile.getActivityLevel())
                .imageUrl(addProfile.getImageUrl())
                .userId(userId)
                .createdAt(Date.from(LocalDate.now().atStartOfDay(ZoneId.systemDefault()).toInstant()))
                .build();
        return fitProfileRepository.save(profile);
    }

    @Override
    public FitProfile updateProfile(UUID userId, FitProfile updateProfile) {
        FitProfile profile = findProfile(userId);

        profile.setName(updateProfile.getName() == null ? profile.getName() : updateProfile.getName());
        profile.setAge(updateProfile.getAge() == null ? profile.getAge() : updateProfile.getAge());
        profile.setGender(updateProfile.getGender() == null ? profile.getGender() : updateProfile.getGender());
        profile.setHeight(updateProfile.getHeight() == null ? profile.getHeight() : updateProfile.getHeight());
        profile.setActivityLevel(updateProfile.getActivityLevel() == null ? profile.getActivityLevel()
                : updateProfile.getActivityLevel());
        profile.setImageUrl(updateProfile.getImageUrl() == null ? profile.getImageUrl() : updateProfile.getImageUrl());

        return fitProfileRepository.save(profile);
    }

    @Override
    public ApiResponse<FitProfileResponse> getFindProfileResponse(UUID userID) {
        FitProfile profile = findProfile(userID);
        FitProfileResponse fitProfileResponse = fitProfileMapper.convertToFitProfileDto(profile);
        return ApiResponse.<FitProfileResponse>builder()
                .status(HttpStatus.OK.value())
                .generalMessage("Get profile successfully!")
                .data(fitProfileResponse)
                .build();
    }

    @Override
    public ApiResponse<?> getUpdateProfileResponse(UUID userId, UpdateProfileRequest updateProfileRequest, 
                                                   MultipartFile imageFile) {
        String imageUrl = null;
        if (imageFile != null && !imageFile.isEmpty()) {
            ApiResponse<Map<String, String>> imageResponse = mediaServiceClient.uploadImage(imageFile);

            imageUrl = imageResponse.getData().get("url");
        }
        
        FitProfile updateProfile = FitProfile.builder()
                .name(updateProfileRequest.getName())
                .age(updateProfileRequest.getAge())
                .gender(Gender.fromString(updateProfileRequest.getGender()))
                .height(updateProfileRequest.getHeight())
                .activityLevel(ActivityLevel.valueOf(updateProfileRequest.getActivityLevel()))
                .imageUrl(imageUrl)
                .build();
        FitProfile savedProfile = updateProfile(userId, updateProfile);
        if (savedProfile == null) {
            throw new StatisticException("Failed to update profile!");
        }
        nutritionGoalService.updateNutritionGoal(userId, savedProfile);
        return ApiResponse.builder()
                .status(HttpStatus.OK.value())
                .generalMessage("Update profile successfully for " + updateProfile.getName() + "!")
                .build();
    }
}
