package com.hcmus.foodservice.event.command;
import lombok.*;

import java.util.UUID;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CreateFoodCommand {
    private String name;
    private Integer calories;
    private Double protein;
    private Double carbs;
    private Double fat;
    private String imageUrl;
    private UUID userId;
}
