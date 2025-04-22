package com.hcmus.userservice.model.type;

public enum ActivityLevel {
    SEDENTARY("SEDENTARY"),
    LIGHT("LIGHT"),
    MODERATE("MODERATE"),
    ACTIVE("ACTIVE"),
    VERY_ACTIVE("VERY_ACTIVE");

    private final String value;

    private ActivityLevel(String value) {
        this.value = value;
    }

    public String getValue() {
        return value;
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
