package com.hcmus.userservice.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.*;

import java.io.Serializable;
import java.util.UUID;

@Setter
@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class UserDto implements Serializable {

    private String name;

    private Integer age;

    private String gender;

    private Double height;

    private Double weight;

    private String email;

    private String imageUrl;

    private UUID goalId;
}