package com.hcmus.statisticservice.application.dto.request;

import lombok.*;

@Setter
@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class UpdateProfileRequest {

    private String name;

    private Integer age;

    private String gender;

    private Integer height;

    private String activityLevel;

    private String imageUrl;
}
