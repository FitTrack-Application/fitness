package com.hcmus.userservice.model.type;

public enum Role {
    USER("USER"), ADMIN("ADMIN");

    private final String value;

    private Role(String value) {
        this.value = value;
    }

    public static Role fromString(String roleStr) {
        for (Role role : Role.values()) {
            if (roleStr.equalsIgnoreCase(role.value)) {
                return role;
            }
        }
        return Role.USER;
    }
}