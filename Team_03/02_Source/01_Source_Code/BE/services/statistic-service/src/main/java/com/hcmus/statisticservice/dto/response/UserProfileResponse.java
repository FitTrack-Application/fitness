package com.hcmus.statisticservice.dto.response;

import lombok.*;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
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
