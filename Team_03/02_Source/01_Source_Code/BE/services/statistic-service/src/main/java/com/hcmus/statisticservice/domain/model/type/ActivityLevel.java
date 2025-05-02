package com.hcmus.statisticservice.domain.model.type;

import lombok.Getter;

@Getter
public enum ActivityLevel {
    SEDENTARY("SEDENTARY"),
    LIGHT("LIGHT"),
    MODERATE("MODERATE"),
    ACTIVE("ACTIVE"),
    VERY_ACTIVE("VERY_ACTIVE");

    private final String value;

    ActivityLevel(String value) {
        this.value = value;
    }

    public static ActivityLevel fromString(String levelStr) {
        for (ActivityLevel level : ActivityLevel.values()) {
            if (levelStr.equalsIgnoreCase(level.value)) {
                return level;
            }
        }
        return null;
    }
}