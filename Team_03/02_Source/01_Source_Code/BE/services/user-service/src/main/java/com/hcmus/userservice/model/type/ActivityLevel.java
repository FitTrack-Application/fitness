package com.hcmus.userservice.model.type;

public enum ActivityLevel {
    LEVEL1("LEVEL1"), LEVEL2("LEVEL2");

    private final String value;

    private ActivityLevel(String value) {
        this.value = value;
    }

    public static ActivityLevel fromString(String genderStr) {
        for (ActivityLevel level : ActivityLevel.values()) {
            if (genderStr.equalsIgnoreCase(level.value)) {
                return level;
            }
        }
        return null;
    }
}