package com.hcmus.foodservice.util;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Component
public class CustomSecurityContextHolder {
    public static UUID getCurrentUserId() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.isAuthenticated()) {
            try {
                return UUID.fromString(authentication.getPrincipal().toString());
            } catch (IllegalArgumentException e) {
                throw new RuntimeException("Invalid UUID format in principal: " + authentication.getPrincipal());
            }
        }
        return null;
    }

    public static List<String> getCurrentUserRoles() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.isAuthenticated()) {
            return authentication.getAuthorities().stream()
                    .map(authority -> authority.getAuthority().replace("ROLE_", ""))
                    .collect(Collectors.toList());
        }
        return List.of();
    }

    public static String getCurrentUserRolesAsString() {
        return String.join(",", getCurrentUserRoles());
    }

    public static boolean hasRole(String role) {
        return getCurrentUserRoles().stream()
                .anyMatch(r -> r.equalsIgnoreCase(role));
    }
}