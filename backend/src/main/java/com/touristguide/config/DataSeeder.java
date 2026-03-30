package com.touristguide.config;

import com.touristguide.features.auth.model.AppUser;
import com.touristguide.features.auth.model.UserRole;
import com.touristguide.features.auth.repository.UserRepository;
import com.touristguide.features.guides.model.Guide;
import com.touristguide.features.guides.repository.GuideRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * Insère les données initiales au démarrage si la base est vide.
 * Les 5 guides sont identiques aux données dans GuidesMockData.dart Flutter,
 * ce qui permet de valider l'intégration sans changer le frontend.
 */
@Component
@RequiredArgsConstructor
@Slf4j
public class DataSeeder implements CommandLineRunner {

    private final GuideRepository guideRepository;
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) {
        seedGuides();
        seedTestUser();
    }

    private void seedGuides() {
        if (guideRepository.count() > 0) {
            log.info("Guides already seeded, skipping.");
            return;
        }

        List<Guide> guides = List.of(
            Guide.builder()
                .name("Ahmed Guide")
                .languages(List.of("Arabic", "French", "English"))
                .priceMin(200.0).priceMax(500.0)
                .rating(4.8)
                .city("Marrakech")
                .transportAvailable(true)
                .description("Passionate about the history of Marrakech. I offer immersive tours in the Medina, historical monuments, and hidden gems.")
                .profileImage("")
                .reviewsCount(124)
                .build(),

            Guide.builder()
                .name("Sofia Tours")
                .languages(List.of("English", "Spanish"))
                .priceMin(300.0).priceMax(800.0)
                .rating(4.9)
                .city("Fez")
                .transportAvailable(false)
                .description("Specialized in culinary and cultural tours. Discover the oldest Medina in the world with a local expert.")
                .profileImage("")
                .reviewsCount(89)
                .build(),

            Guide.builder()
                .name("Youssef Explorer")
                .languages(List.of("Arabic", "English", "German"))
                .priceMin(150.0).priceMax(400.0)
                .rating(4.5)
                .city("Casablanca")
                .transportAvailable(true)
                .description("Explore the modern and traditional sides of Casablanca. Hassan II Mosque, Habous, and coastal rides.")
                .profileImage("")
                .reviewsCount(56)
                .build(),

            Guide.builder()
                .name("Layla Atlas")
                .languages(List.of("French", "English", "Italian"))
                .priceMin(400.0).priceMax(1000.0)
                .rating(4.9)
                .city("Marrakech")
                .transportAvailable(true)
                .description("Trekking and mountain tours in the Atlas Mountains, just a few hours from Marrakech.")
                .profileImage("")
                .reviewsCount(201)
                .build(),

            Guide.builder()
                .name("Mehdi Blue")
                .languages(List.of("Arabic", "French"))
                .priceMin(200.0).priceMax(350.0)
                .rating(4.6)
                .city("Chefchaouen")
                .transportAvailable(false)
                .description("Photography and walking tours in the blue pearl of Morocco. I know all the best spots for pictures.")
                .profileImage("")
                .reviewsCount(42)
                .build()
        );

        guideRepository.saveAll(guides);
        log.info("Seeded {} guides.", guides.size());
    }

    private void seedTestUser() {
        if (userRepository.existsByEmail("test@example.com")) {
            log.info("Test user already exists, skipping.");
            return;
        }

        // Correspond aux credentials hardcodés dans AuthRemoteDataSourceImpl.dart Flutter
        AppUser testUser = AppUser.builder()
                .name("Test User")
                .email("test@example.com")
                .password(passwordEncoder.encode("password123"))
                .role(UserRole.TOURIST)
                .build();

        userRepository.save(testUser);
        log.info("Seeded test user: test@example.com / password123");
    }
}
