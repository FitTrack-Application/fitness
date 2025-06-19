package com.hcmus.statisticservice.domain.model.type;

import lombok.Getter;

@Getter
public enum Gender {
    MALE("MALE"),
    FEMALE("FEMALE"),
    OTHER("OTHER");

    private final String value;

    Gender(String value) {
        this.value = value;
    }

    public static Gender fromString(String genderStr) {
        for (Gender gender : Gender.values()) {
            if (genderStr.equalsIgnoreCase(gender.value)) {
                return gender;
            }
        }
        return Gender.OTHER;
    }
}