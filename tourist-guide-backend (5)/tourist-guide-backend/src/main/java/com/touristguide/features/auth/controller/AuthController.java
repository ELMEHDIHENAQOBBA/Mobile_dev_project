package com.touristguide.features.auth.controller;

import com.touristguide.features.auth.dto.AuthResponse;
import com.touristguide.features.auth.dto.LoginRequest;
import com.touristguide.features.auth.dto.RegisterRequest;
import com.touristguide.features.auth.service.AuthService;
import com.touristguide.shared.response.ApiResponse;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    /**
     * POST /api/auth/register
     * Correspond à IAuthRemoteDataSource.signUp() Flutter
     *
     * Body: { "name": "...", "email": "...", "password": "..." }
     * Returns: { "success": true, "data": { "token": "...", "user": {...} } }
     */
    @PostMapping("/register")
    public ResponseEntity<ApiResponse<AuthResponse>> register(
            @Valid @RequestBody RegisterRequest request) {
        AuthResponse response = authService.register(request);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.ok("Account created successfully", response));
    }

    /**
     * POST /api/auth/login
     * Correspond à IAuthRemoteDataSource.signIn() Flutter
     *
     * Body: { "email": "...", "password": "..." }
     * Returns: { "success": true, "data": { "token": "...", "user": {...} } }
     */
    @PostMapping("/login")
    public ResponseEntity<ApiResponse<AuthResponse>> login(
            @Valid @RequestBody LoginRequest request) {
        AuthResponse response = authService.login(request);
        return ResponseEntity.ok(ApiResponse.ok("Login successful", response));
    }
}
