package com.roo.feature.security;

import java.nio.charset.StandardCharsets;
import java.util.Date;

import javax.crypto.SecretKey;

import org.springframework.stereotype.Component;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;

@Component
public class JwtTokenService {

    private static final long TOKEN_TTL_MS = 1000L * 60 * 60 * 4;
    private static final String SECRET = "online-faculty-recruitment-system-jwt-secret-key-2026";

    public String generateToken(String subject, UserRole role) {
        Date now = new Date();
        Date expiry = new Date(now.getTime() + TOKEN_TTL_MS);

        return Jwts.builder()
                .subject(subject)
                .claim("role", role.name())
                .issuedAt(now)
                .expiration(expiry)
                .signWith(getKey())
                .compact();
    }

    public Claims parse(String token) {
        return Jwts.parser()
                .verifyWith(getKey())
                .build()
                .parseSignedClaims(token)
                .getPayload();
    }

    private SecretKey getKey() {
        return Keys.hmacShaKeyFor(SECRET.getBytes(StandardCharsets.UTF_8));
    }
}
