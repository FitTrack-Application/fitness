package com.hcmus.userservice.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Builder;
import lombok.Data;



@Data
@Builder
public class UserUpdateRequest {
    @NotBlank(message = "Name is required")
    private String name;

    private Integer age;

    private String gender;

    private Double height;

    private Double weight;

    private String imageUrl;

}
