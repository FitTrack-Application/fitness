package com.hcmus.foodservice.event.command;

import lombok.*;
import java.util.UUID;

@Builder
@Getter
public class DeleteFoodCommand {
    private UUID foodId;
    private UUID userId;
}
