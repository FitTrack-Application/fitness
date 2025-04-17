package com.hcmus.statisticservice.client;

import com.hcmus.statisticservice.dto.request.UpdateProfileRequest;
import com.hcmus.statisticservice.dto.response.ApiResponse;
import com.hcmus.statisticservice.dto.response.UserProfileResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;

@FeignClient(name = "userClient", url = "${host.user-service}")
public interface UserClient {

    @GetMapping("/api/users/me")
    ApiResponse<UserProfileResponse> getUserProfile(
        @RequestHeader("Authorization") String authorizationHeader);

    @PutMapping("/api/users/me")
    ApiResponse<?> updateUserProfile(
        @RequestBody UpdateProfileRequest updateProfileRequest, 
        @RequestHeader("Authorization") String authorizationHeader);
}
