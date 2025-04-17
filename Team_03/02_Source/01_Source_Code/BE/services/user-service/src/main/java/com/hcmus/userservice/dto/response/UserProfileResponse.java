package com.hcmus.userservice.dto.response;

import lombok.*;

@Setter
@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class UserProfileResponse {

    private String name;

    private Integer age;

    private String gender;

    private Integer height;

    private Double weight;

    private String email;

    private String activityLevel;

    private String imageUrl;
}