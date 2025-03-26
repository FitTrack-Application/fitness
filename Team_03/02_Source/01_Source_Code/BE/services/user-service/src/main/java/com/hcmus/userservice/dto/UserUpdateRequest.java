package main.java.com.hcmus.userservice.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;


@Data
public class UserUpdateRequest {
    @NotBlank(message = "Name is required")
    private String name;

    private Integer age;

    private String gender;

    private Double height;

    private Double weight;

    private String imageUrl;

}
