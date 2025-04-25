package com.hcmus.fitservice.util;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.stereotype.Component;

import java.util.Map;
import java.util.Optional;


@Component
public class JwtUtil {

    private static final String USER_ID_CLAIM = "sub";
    private static final String EMAIL_CLAIM = "email";
    private static final String USERNAME_CLAIM = "preferred_username";

    public String getCurrentUserId() {
        return getClaimFromToken(USER_ID_CLAIM).orElse(null);
    }

    public String getCurrentUserEmail() {
        return getClaimFromToken(EMAIL_CLAIM).orElse(null);
    }

    public String getCurrentUsername() {
        return getClaimFromToken(USERNAME_CLAIM).orElse(null);
    }

    public Map<String, Object> getAllClaims() {
        return getCurrentJwt()
                .map(Jwt::getClaims)
                .orElse(Map.of());
    }

    public Optional<String> getClaimFromToken(String claimName) {
        return getCurrentJwt()
                .map(jwt -> jwt.getClaimAsString(claimName));
    }

    private Optional<Jwt> getCurrentJwt() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.getPrincipal() instanceof Jwt) {
            return Optional.of((Jwt) authentication.getPrincipal());
        }
        return Optional.empty();
    }
}