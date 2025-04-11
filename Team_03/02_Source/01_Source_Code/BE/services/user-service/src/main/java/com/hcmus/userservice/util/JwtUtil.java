package com.hcmus.userservice.util;

import com.hcmus.userservice.exception.InvalidTokenException;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import java.security.Key;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;

@Component
public class JwtUtil {

    @Value("${jwt.secret}")
    private String jwtSecretKey;

    @Value("${jwt.expiration}")
    private long jwtExpiration;

    @Value("${jwt.refresh-expiration}")
    private long refreshTokenExpiration;

    public String extractUsername(String token) {
        return extractClaim(token, Claims::getSubject);
    }

    public <T> T extractClaim(String token, Function<Claims, T> claimsResolver) {
        final Claims claims = extractAllClaims(token);
        return claimsResolver.apply(claims);
    }

    public String generateToken(UserDetails userDetails) {
        Map<String, Object> claims = new HashMap<>();
        if (userDetails instanceof User user) {
            claims.put("userId", user.getUserId().toString());
            claims.put("name", user.getName());
            claims.put("role", user.getRole().name());
        }
        return generateToken(claims, userDetails, jwtExpiration);
    }

    public String generateRefreshToken(UserDetails userDetails) {
        Map<String, Object> claims = new HashMap<>();
        if (userDetails instanceof User user) {
            claims.put("userId", user.getUserId().toString());
            claims.put("tokenType", "refresh");
        }
        return generateToken(claims, userDetails, refreshTokenExpiration);
    }

    public String generateToken(Map<String, Object> extraClaims, UserDetails userDetails, long expireIn) {
        return Jwts.builder()
                .setClaims(extraClaims)
                .setSubject(userDetails.getUsername())
                .setIssuedAt(new Date(System.currentTimeMillis()))
                .setExpiration(new Date(System.currentTimeMillis() + expireIn))
                .signWith(getSignInKey(), SignatureAlgorithm.HS256)
                .compact();
    }

    public boolean isTokenValid(String token, UserDetails userDetails) {
        final String username = extractUsername(token);
        return (username.equals(userDetails.getUsername())) && !isTokenExpired(token);
    }

    public String extractUserId(String token) {
        return extractClaim(token, claims -> claims.get("userId", String.class));
    }

    public Map<String, Object> validateTokenAndGetClaims(String token) {
        try {
            Claims claims = extractAllClaims(token);
            if (isTokenExpired(token)) {
                throw new InvalidTokenException("Token has expired!");
            }

            Map<String, Object> claimsMap = new HashMap<>();
            claimsMap.put("userId", claims.get("userId", String.class));
            claimsMap.put("name", claims.get("name", String.class));
            claimsMap.put("role", claims.get("role", String.class));
            claimsMap.put("email", claims.getSubject());
            claimsMap.put("exp", claims.getExpiration().getTime());
            claimsMap.put("iat", claims.getIssuedAt().getTime());

            return claimsMap;
        } catch (Exception e) {
            throw new InvalidTokenException("Failed to parse token: " + e.getMessage() + "!");
        }
    }

    public Map<String, Object> validateRefreshTokenAndGetClaims(String token) {
        try {
            Claims claims = extractAllClaims(token);
            if (isTokenExpired(token)) {
                throw new InvalidTokenException("Refresh token has expired!");
            }
            String tokenType = claims.get("tokenType", String.class);
            if (!"refresh".equals(tokenType)) {
                throw new InvalidTokenException("Not a refresh token!");
            }
            return claims;
        } catch (Exception e) {
            throw new InvalidTokenException("Failed to parse refresh token: " + e.getMessage() + "!");
        }
    }

    private boolean isTokenExpired(String token) {
        return extractExpiration(token).before(new Date());
    }

    private Key getSignInKey() {
        byte[] keyBytes = Decoders.BASE64.decode(jwtSecretKey);
        return Keys.hmacShaKeyFor(keyBytes);
    }

    private Claims extractAllClaims(String token) {
        return Jwts.parserBuilder()
                .setSigningKey(getSignInKey())
                .build()
                .parseClaimsJws(token)
                .getBody();
    }

    private Date extractExpiration(String token) {
        return extractClaim(token, Claims::getExpiration);
    }
}