package com.vnext.security;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import io.jsonwebtoken.security.SignatureException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;

@Service
public class JwtService {

    @Value("${jwt.secret}")
    private String secret;

    @Value("${jwt.expiration}")
    private Long expiration;

    @Value("${jwt.refresh-expiration}")
    private Long refreshExpiration;

    public Long getExpiration() {
        return expiration != null ? expiration : 15552000000L;
    }

    public Long getRefreshExpiration() {
        return refreshExpiration != null ? refreshExpiration : 31536000000L;
    }

    private SecretKey getSigningKey() {
        byte[] keyBytes = secret.getBytes(StandardCharsets.UTF_8);
        return Keys.hmacShaKeyFor(keyBytes);
    }

    public String extractUsername(String token) {
        try {
            return extractClaim(token, Claims::getSubject);
        } catch (SignatureException e) {
            throw new RuntimeException("Invalid JWT signature", e);
        } catch (Exception e) {
            throw new RuntimeException("Invalid JWT token", e);
        }
    }

    public <T> T extractClaim(String token, Function<Claims, T> claimsResolver) {
        final Claims claims = extractAllClaims(token);
        return claimsResolver.apply(claims);
    }

    private Claims extractAllClaims(String token) {
        try {
            return Jwts.parser()
                    .verifyWith(getSigningKey())
                    .build()
                    .parseSignedClaims(token)
                    .getPayload();
        } catch (Exception e) {
            throw new RuntimeException("Failed to parse JWT token: " + e.getMessage(), e);
        }
    }

    public String generateToken(UserDetails userDetails) {
        return generateToken(new HashMap<>(), userDetails, expiration);
    }

    public String generateRefreshToken(UserDetails userDetails) {
        return generateToken(new HashMap<>(), userDetails, refreshExpiration);
    }

    public String generateToken(Map<String, Object> extraClaims, UserDetails userDetails, Long expirationTime) {
        return Jwts.builder()
                .claims(extraClaims)
                .subject(userDetails.getUsername())
                .issuedAt(new Date(System.currentTimeMillis()))
                .expiration(new Date(System.currentTimeMillis() + expirationTime))
                .signWith(getSigningKey())
                .compact();
    }

    @org.springframework.beans.factory.annotation.Autowired(required = false)
    private com.vnext.repository.NotificationScheduleConfigRepository scheduleConfigRepository;

    private final java.util.concurrent.atomic.AtomicLong globalRevocationTimestamp = new java.util.concurrent.atomic.AtomicLong(0L);

    @jakarta.annotation.PostConstruct
    public void init() {
        try {
            if (scheduleConfigRepository != null) {
                scheduleConfigRepository.findByNotificationType("GLOBAL_JWT_REVOCATION")
                        .ifPresent(cfg -> {
                            if (cfg.getLastSentAt() != null) {
                                long epoch = cfg.getLastSentAt().atZone(java.time.ZoneId.of("Asia/Kolkata")).toInstant().toEpochMilli();
                                globalRevocationTimestamp.set(epoch);
                            }
                        });
            }
        } catch (Exception ignored) {}
    }

    public void revokeAllTokens() {
        long now = System.currentTimeMillis();
        globalRevocationTimestamp.set(now);
        try {
            if (scheduleConfigRepository != null) {
                var cfg = scheduleConfigRepository.findByNotificationType("GLOBAL_JWT_REVOCATION")
                        .orElseGet(() -> {
                            var c = new com.vnext.entity.NotificationScheduleConfig();
                            c.setNotificationType("GLOBAL_JWT_REVOCATION");
                            c.setEnabled(true);
                            c.setTimesPerDay(1);
                            c.setStartHour(0);
                            c.setEndHour(23);
                            return c;
                        });
                cfg.setLastSentAt(java.time.LocalDateTime.now(java.time.ZoneId.of("Asia/Kolkata")));
                scheduleConfigRepository.save(cfg);
            }
        } catch (Exception ignored) {}
    }

    public long getGlobalRevocationTimestamp() {
        return globalRevocationTimestamp.get();
    }

    public boolean isTokenValid(String token, UserDetails userDetails) {
        try {
            final String username = extractUsername(token);
            Date issuedAt = extractClaim(token, Claims::getIssuedAt);
            if (issuedAt != null && issuedAt.getTime() < globalRevocationTimestamp.get()) {
                return false;
            }
            return (username.equals(userDetails.getUsername())) && !isTokenExpired(token);
        } catch (Exception e) {
            return false;
        }
    }

    private boolean isTokenExpired(String token) {
        return extractExpiration(token).before(new Date());
    }

    private Date extractExpiration(String token) {
        return extractClaim(token, Claims::getExpiration);
    }
}