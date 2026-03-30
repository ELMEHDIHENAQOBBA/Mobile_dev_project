package com.touristguide.features.guides.model;

import jakarta.persistence.*;
import lombok.*;

import java.util.List;

/**
 * Entité Guide — champs alignés 1:1 avec GuideEntity Flutter :
 * id, name, languages, priceMin, priceMax, rating,
 * city, transportAvailable, description, profileImage, reviewsCount
 */
@Entity
@Table(name = "guides")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Guide {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    // Stocké comme tableau PostgreSQL via JPA
    @ElementCollection
    @CollectionTable(name = "guide_languages", joinColumns = @JoinColumn(name = "guide_id"))
    @Column(name = "language")
    private List<String> languages;

    @Column(name = "price_min", nullable = false)
    private Double priceMin;

    @Column(name = "price_max", nullable = false)
    private Double priceMax;

    @Column(nullable = false)
    @Builder.Default
    private Double rating = 0.0;

    @Column(nullable = false)
    private String city;

    @Column(name = "transport_available", nullable = false)
    @Builder.Default
    private Boolean transportAvailable = false;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(name = "profile_image")
    private String profileImage;

    @Column(name = "reviews_count", nullable = false)
    @Builder.Default
    private Integer reviewsCount = 0;

    // Lien optionnel vers le compte utilisateur du guide
    @OneToOne
    @JoinColumn(name = "user_id")
    private com.touristguide.features.auth.model.AppUser user;
}
