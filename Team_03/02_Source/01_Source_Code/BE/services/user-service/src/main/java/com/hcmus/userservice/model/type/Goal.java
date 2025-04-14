package com.hcmus.userservice.model.type;

public enum Goal {
    UP("UP"), DOWN("DOWN");

    private final String value;

    private Goal(String value) {
        this.value = value;
    }

    public static Goal fromString(String genderStr) {
        for (Goal goal : Goal.values()) {
            if (genderStr.equalsIgnoreCase(goal.value)) {
                return goal;
            }
        }
        return null;
    }
}