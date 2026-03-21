package com.touristguide.features.auth.service;

import com.touristguide.features.auth.dto.AuthResponse;
import com.touristguide.features.auth.dto.LoginRequest;
import com.touristguide.features.auth.dto.RegisterRequest;
import com.touristguide.features.auth.model.AppUser;
import com.touristguide.features.auth.model.UserRole;
import com.touristguide.features.auth.repository.UserRepository;
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

@Service
@RequiredArgsConstructor
public class AuthService implements UserDetailsService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final AuthenticationManager authenticationManager;

    // ─── UserDetailsService (requis par Spring Security) ─────────────────────

    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        return userRepository.findByEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("User not found: " + email));
    }

    // ─── Register ─────────────────────────────────────────────────────────────

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
        String token = jwtService.generateToken(saved);

        return buildAuthResponse(token, saved);
    }

    // ─── Login ────────────────────────────────────────────────────────────────

    public AuthResponse login(LoginRequest request) {
        // Spring Security valide email + password, lève BadCredentialsException si invalide
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        request.getEmail(),
                        request.getPassword()
                )
        );

        AppUser user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new UsernameNotFoundException("User not found"));

        String token = jwtService.generateToken(user);
        return buildAuthResponse(token, user);
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
