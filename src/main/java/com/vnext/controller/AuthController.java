package com.vnext.controller;

import com.vnext.dto.ApiResponse;
import com.vnext.dto.AuthRequest;
import com.vnext.dto.AuthResponse;
import com.vnext.service.AuthService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    @PostMapping("/login")
    public ApiResponse<AuthResponse> login(
            @Valid @RequestBody AuthRequest request,
            @RequestHeader(value = "X-Device-Token", required = false) String headerDeviceToken) {
        if ((request.getDeviceToken() == null || request.getDeviceToken().trim().isEmpty())
                && headerDeviceToken != null && !headerDeviceToken.trim().isEmpty()) {
            request.setDeviceToken(headerDeviceToken.trim());
        }
        AuthResponse response = authService.login(request);
        return ApiResponse.success(response, "Login successful");
    }

    @PostMapping("/logout")
    public ApiResponse<Void> logout() {
        return ApiResponse.success("Logout successful");
    }
}