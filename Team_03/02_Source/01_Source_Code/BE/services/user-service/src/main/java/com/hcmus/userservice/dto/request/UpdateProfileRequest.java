package com.hcmus.userservice.dto.request;

import com.hcmus.userservice.model.type.Gender;
import com.hcmus.userservice.model.type.Role;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.*;

import java.util.UUID;

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

    private Double weight;

    private String imageUrl;
}
