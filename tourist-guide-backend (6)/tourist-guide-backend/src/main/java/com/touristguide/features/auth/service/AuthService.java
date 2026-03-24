package com.touristguide.features.auth.service;

import com.touristguide.features.auth.dto.AuthResponse;
import com.touristguide.features.auth.dto.LoginRequest;
import com.touristguide.features.auth.dto.RegisterGuideRequest;
import com.touristguide.features.auth.dto.RegisterRequest;
import com.touristguide.features.auth.model.AppUser;
import com.touristguide.features.auth.model.UserRole;
import com.touristguide.features.auth.repository.UserRepository;
import com.touristguide.features.guides.model.Guide;
import com.touristguide.features.guides.repository.GuideRepository;
import com.touristguide.security.jwt.JwtService;
import com.touristguide.shared.exception.EmailAlreadyExistsException;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class AuthService implements UserDetailsService {

    private final UserRepository userRepository;
    private final GuideRepository guideRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final AuthenticationManager authenticationManager;

    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        return userRepository.findByEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("User not found: " + email));
    }

    // ─── Register Tourist ─────────────────────────────────────────────────────

    public AuthResponse register(RegisterRequest request) {
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new EmailAlreadyExistsException(request.getEmail());
        }
        AppUser user = AppUser.builder()
                .name(request.getName())
                .email(request.getEmail())
                .password(passwordEncoder.encode(request.getPassword()))
                .role(UserRole.TOURIST)
                .build();
        AppUser saved = userRepository.save(user);
        return buildAuthResponse(jwtService.generateToken(saved), saved);
    }

    // ─── Register Guide ───────────────────────────────────────────────────────

    @Transactional
    public AuthResponse registerGuide(RegisterGuideRequest request) {
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new EmailAlreadyExistsException(request.getEmail());
        }
        AppUser user = AppUser.builder()
                .name(request.getName())
                .email(request.getEmail())
                .password(passwordEncoder.encode(request.getPassword()))
                .role(UserRole.GUIDE)
                .build();
        AppUser savedUser = userRepository.save(user);

        Guide guide = Guide.builder()
                .name(request.getName())
                .city(request.getCity())
                .description(request.getDescription())
                .priceMin(request.getPriceMin())
                .priceMax(request.getPriceMax())
                .languages(request.getLanguages() != null ? request.getLanguages() : List.of())
                .transportAvailable(request.getTransportAvailable() != null ? request.getTransportAvailable() : false)
                .profileImage(request.getProfileImage() != null ? request.getProfileImage() : "")
                .rating(0.0)
                .reviewsCount(0)
                .user(savedUser)
                .build();
        guideRepository.save(guide);

        return buildAuthResponse(jwtService.generateToken(savedUser), savedUser);
    }

    // ─── Login ────────────────────────────────────────────────────────────────

    public AuthResponse login(LoginRequest request) {
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(request.getEmail(), request.getPassword()));
        AppUser user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new UsernameNotFoundException("User not found"));
        return buildAuthResponse(jwtService.generateToken(user), user);
    }

    // ─── Helper ───────────────────────────────────────────────────────────────

    private AuthResponse buildAuthResponse(String token, AppUser user) {
        return AuthResponse.builder()
                .token(token)
                .user(AuthResponse.UserDto.builder()
                        .id(user.getId())
                        .email(user.getEmail())
                        .name(user.getName())
                        .photoUrl(user.getPhotoUrl())
                        .role(user.getRole().name())
                        .build())
                .build();
    }
}
