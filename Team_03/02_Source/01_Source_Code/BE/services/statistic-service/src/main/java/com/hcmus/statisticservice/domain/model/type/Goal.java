package com.hcmus.statisticservice.domain.model.type;

import lombok.Getter;

@Getter
public enum Goal {
    UP("UP"),
    DOWN("DOWN");

    private final String value;

    Goal(String value) {
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