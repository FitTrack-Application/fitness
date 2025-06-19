package com.hcmus.statisticservice.application.mapper;

import com.hcmus.statisticservice.application.dto.response.FitProfileResponse;
import com.hcmus.statisticservice.domain.model.FitProfile;
import org.springframework.stereotype.Component;

@Component
public class FitProfileMapper {
    public FitProfileResponse convertToFitProfileDto(FitProfile profile) {
        return FitProfileResponse.builder()
                .age(profile.getAge())
                .name(profile.getName())
                .gender(profile.getGender().toString())
                .height(profile.getHeight())
                .imageUrl(profile.getImageUrl())
                .activityLevel(profile.getActivityLevel().name())
                .build();
    }
}
