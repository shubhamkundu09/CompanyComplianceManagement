package com.vnext.security;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.vnext.entity.User;
import com.vnext.repository.UserRepository;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.lang.NonNull;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

@Component
@RequiredArgsConstructor
@Slf4j
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final JwtService jwtService;
    private final UserDetailsService userDetailsService;
    private final UserRepository userRepository;

    @Override
    protected void doFilterInternal(@NonNull HttpServletRequest request,
                                    @NonNull HttpServletResponse response,
                                    @NonNull FilterChain filterChain) throws ServletException, IOException {

        String path = request.getServletPath();

        // Skip JWT validation for public paths (including file endpoints)
        if (isPublicPath(path)) {
            log.debug("Skipping JWT validation for public path: {}", path);
            filterChain.doFilter(request, response);
            return;
        }

        // For API endpoints that are NOT public, require authentication
        if (path.startsWith("/api/")) {
            final String authHeader = request.getHeader("Authorization");

            if (authHeader == null || !authHeader.startsWith("Bearer ")) {
                log.debug("No JWT token found for API request: {}", path);
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.setContentType("application/json");
                response.getWriter().write("{\"error\":\"Authentication required\"}");
                return;
            }

            final String jwt = authHeader.substring(7);

            try {
                String userEmail = jwtService.extractUsername(jwt);
                log.debug("Extracted email from JWT: {}", userEmail);

                if (userEmail != null && SecurityContextHolder.getContext().getAuthentication() == null) {
                    UserDetails userDetails = this.userDetailsService.loadUserByUsername(userEmail);

                    if (jwtService.isTokenValid(jwt, userDetails)) {
                        UsernamePasswordAuthenticationToken authToken = new UsernamePasswordAuthenticationToken(
                                userDetails,
                                null,
                                userDetails.getAuthorities()
                        );
                        authToken.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                        SecurityContextHolder.getContext().setAuthentication(authToken);
                        log.debug("Authentication successful for user: {}", userEmail);
                    } else {
                        log.debug("Invalid JWT token for user: {}", userEmail);
                        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                        response.setContentType("application/json");
                        response.getWriter().write("{\"error\":\"Invalid token\"}");
                        return;
                    }
                }
            } catch (Exception e) {
                log.error("JWT validation error: {}", e.getMessage());
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.setContentType("application/json");
                response.getWriter().write("{\"error\":\"Invalid or expired token\"}");
                return;
            }
        }

        filterChain.doFilter(request, response);
    }

    private boolean isPublicPath(String path) {
        return path.equals("/") ||
                path.equals("/login") ||
                path.startsWith("/login?") ||
                path.startsWith("/super-admin/") ||
                path.startsWith("/company-admin/") ||
                path.startsWith("/employee/") ||
                path.equals("/profile") ||
                path.equals("/change-password") ||
                path.equals("/api/auth/login") ||
                path.startsWith("/api/auth/") ||
                path.startsWith("/api/public/") ||
                // ADD THESE LINES - Make file endpoints public in the filter too
                path.startsWith("/api/files/") ||
                path.startsWith("/uploads/") ||
                path.startsWith("/css/") ||
                path.startsWith("/js/") ||
                path.startsWith("/assets/") ||
                path.startsWith("/static/") ||
                path.equals("/favicon.ico") ||
                path.equals("/error");
    }
}