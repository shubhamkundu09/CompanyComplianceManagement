package com.vnext.security;

import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.Arrays;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    private final JwtAuthenticationFilter jwtAuthenticationFilter;
    private final UserDetailsService userDetailsService;

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {

        http
                .csrf(AbstractHttpConfigurer::disable)
                .cors(cors -> cors.configurationSource(corsConfigurationSource()))
                .sessionManagement(session ->
                        session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))

                .authorizeHttpRequests(auth -> auth

                        // ======================================================
                        // IMAGES & FILES
                        // ======================================================
                        .requestMatchers(
                                AntPathRequestMatcher.antMatcher("/vnextimages/**"),
                                AntPathRequestMatcher.antMatcher("/vnextimages/**/*.png"),
                                AntPathRequestMatcher.antMatcher("/vnextimages/**/*.jpg"),
                                AntPathRequestMatcher.antMatcher("/vnextimages/**/*.jpeg"),
                                AntPathRequestMatcher.antMatcher("/vnextimages/**/*.gif"),
                                AntPathRequestMatcher.antMatcher("/vnextimages/**/*.webp"),
                                AntPathRequestMatcher.antMatcher("/localimages/**"),
                                AntPathRequestMatcher.antMatcher("/localimages/**/*.png"),
                                AntPathRequestMatcher.antMatcher("/localimages/**/*.jpg"),
                                AntPathRequestMatcher.antMatcher("/localimages/**/*.jpeg"),
                                AntPathRequestMatcher.antMatcher("/localimages/**/*.gif"),
                                AntPathRequestMatcher.antMatcher("/localimages/**/*.webp"),
                                AntPathRequestMatcher.antMatcher("/uploads/**"),
                                AntPathRequestMatcher.antMatcher("/api/files/**")
                        ).permitAll()

                        // ======================================================
                        // STATIC RESOURCES
                        // ======================================================
                        .requestMatchers(
                                AntPathRequestMatcher.antMatcher("/css/**"),
                                AntPathRequestMatcher.antMatcher("/js/**"),
                                AntPathRequestMatcher.antMatcher("/assets/**"),
                                AntPathRequestMatcher.antMatcher("/static/**"),
                                AntPathRequestMatcher.antMatcher("/resources/**"),
                                AntPathRequestMatcher.antMatcher("/webjars/**"),
                                AntPathRequestMatcher.antMatcher("/favicon.ico")
                        ).permitAll()

                        // ======================================================
                        // STATIC FILE EXTENSIONS
                        // ======================================================
                        .requestMatchers(
                                AntPathRequestMatcher.antMatcher("/**/*.css"),
                                AntPathRequestMatcher.antMatcher("/**/*.js"),
                                AntPathRequestMatcher.antMatcher("/**/*.png"),
                                AntPathRequestMatcher.antMatcher("/**/*.jpg"),
                                AntPathRequestMatcher.antMatcher("/**/*.jpeg"),
                                AntPathRequestMatcher.antMatcher("/**/*.gif"),
                                AntPathRequestMatcher.antMatcher("/**/*.svg"),
                                AntPathRequestMatcher.antMatcher("/**/*.ico"),
                                AntPathRequestMatcher.antMatcher("/**/*.webp"),
                                AntPathRequestMatcher.antMatcher("/**/*.woff"),
                                AntPathRequestMatcher.antMatcher("/**/*.woff2"),
                                AntPathRequestMatcher.antMatcher("/**/*.ttf"),
                                AntPathRequestMatcher.antMatcher("/**/*.eot")
                        ).permitAll()

                        // ======================================================
                        // PUBLIC PAGES
                        // ======================================================
                        .requestMatchers(
                                AntPathRequestMatcher.antMatcher("/"),
                                AntPathRequestMatcher.antMatcher("/login"),
                                AntPathRequestMatcher.antMatcher("/error"),
                                AntPathRequestMatcher.antMatcher("/favicon.ico"),
                                AntPathRequestMatcher.antMatcher("/WEB-INF/views/**")
                        ).permitAll()

                        // ======================================================
                        // PUBLIC API
                        // ======================================================
                        .requestMatchers(
                                AntPathRequestMatcher.antMatcher("/api/auth/**"),
                                AntPathRequestMatcher.antMatcher("/api/public/**")
                        ).permitAll()

                        // ======================================================
                        // PROTECTED API
                        // ======================================================
                        .requestMatchers(
                                AntPathRequestMatcher.antMatcher("/api/**")
                        ).authenticated()

                        // ======================================================
                        // APPLICATION PAGES
                        // ======================================================
                        
                        // ======================================================
                        // EVERYTHING ELSE
                        // ======================================================
                        .anyRequest().permitAll()
                );

        http.authenticationProvider(authenticationProvider());
        http.addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {

        CorsConfiguration configuration = new CorsConfiguration();

        // Allow all origins
        configuration.addAllowedOriginPattern("*");

        // Allow all HTTP methods
        configuration.addAllowedMethod("*");

        // Allow all headers
        configuration.addAllowedHeader("*");

        // Expose headers if needed
        configuration.addExposedHeader("*");

        // Set to false when allowing all origins
        configuration.setAllowCredentials(false);

        configuration.setMaxAge(3600L);

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);

        return source;
    }

    @Bean
    public AuthenticationProvider authenticationProvider() {

        DaoAuthenticationProvider provider = new DaoAuthenticationProvider();
        provider.setUserDetailsService(userDetailsService);
        provider.setPasswordEncoder(passwordEncoder());

        return provider;
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration configuration)
            throws Exception {
        return configuration.getAuthenticationManager();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}