package com.touristguide.features.auth.controller;

import com.touristguide.features.auth.dto.AuthResponse;
import com.touristguide.features.auth.dto.LoginRequest;
import com.touristguide.features.auth.dto.RegisterGuideRequest;
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

    @PostMapping("/register")
    public ResponseEntity<ApiResponse<AuthResponse>> register(@Valid @RequestBody RegisterRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.ok("Account created successfully", authService.register(request)));
    }

    @PostMapping("/register/guide")
    public ResponseEntity<ApiResponse<AuthResponse>> registerGuide(@Valid @RequestBody RegisterGuideRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.ok("Guide account created successfully", authService.registerGuide(request)));
    }

    @PostMapping("/login")
    public ResponseEntity<ApiResponse<AuthResponse>> login(@Valid @RequestBody LoginRequest request) {
        return ResponseEntity.ok(ApiResponse.ok("Login successful", authService.login(request)));
    }
}
