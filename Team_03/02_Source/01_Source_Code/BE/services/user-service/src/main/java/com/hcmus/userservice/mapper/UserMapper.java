package com.hcmus.userservice.mapper;

import com.hcmus.userservice.dto.response.UserProfileResponse;
import com.hcmus.userservice.model.User;
import org.mapstruct.Mapper;
import org.mapstruct.ReportingPolicy;
import org.mapstruct.factory.Mappers;
import org.springframework.stereotype.Component;

@Component
public class UserMapper {

    public UserProfileResponse convertToUserDto(User user) {
        return UserProfileResponse.builder()
                .age(user.getAge())
                .email(user.getEmail())
                .name(user.getName())
                .gender(user.getGender().toString())
                .height(user.getHeight())
                .imageUrl(user.getImageUrl())
                .weight(user.getWeight())
                .activityLevel(user.getActivityLevel())
                .build();
    }
}
