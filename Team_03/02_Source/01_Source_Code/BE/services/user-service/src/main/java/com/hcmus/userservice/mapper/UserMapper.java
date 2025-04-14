package com.hcmus.userservice.mapper;

import com.hcmus.userservice.dto.response.UserProfileResponse;
import com.hcmus.userservice.model.User;
import org.mapstruct.Mapper;
import org.mapstruct.ReportingPolicy;
import org.mapstruct.factory.Mappers;

@Mapper(unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface UserMapper {

    UserMapper INSTANCE = Mappers.getMapper(UserMapper.class);

    UserProfileResponse convertToUserDto(User user);
}
