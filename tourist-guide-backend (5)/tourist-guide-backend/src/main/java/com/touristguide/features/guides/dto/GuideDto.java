package com.touristguide.features.guides.dto;

import com.touristguide.features.guides.model.Guide;
import lombok.Builder;
import lombok.Data;

import java.util.List;

/**
 * Réponse JSON alignée exactement sur GuideEntity Flutter.
 * Chaque champ correspond à un champ de la classe GuideEntity Dart.
 */
@Data
@Builder
public class GuideDto {

    private Long id;
    private String name;
    private List<String> languages;
    private Double priceMin;
    private Double priceMax;
    private Double rating;
    private String city;
    private Boolean transportAvailable;
    private String description;
    private String profileImage;
    private Integer reviewsCount;

    public static GuideDto fromEntity(Guide guide) {
        return GuideDto.builder()
                .id(guide.getId())
                .name(guide.getName())
                .languages(guide.getLanguages())
                .priceMin(guide.getPriceMin())
                .priceMax(guide.getPriceMax())
                .rating(guide.getRating())
                .city(guide.getCity())
                .transportAvailable(guide.getTransportAvailable())
                .description(guide.getDescription())
                .profileImage(guide.getProfileImage())
                .reviewsCount(guide.getReviewsCount())
                .build();
    }
}
