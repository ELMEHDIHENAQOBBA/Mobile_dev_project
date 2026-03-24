package com.touristguide.features.guides.service;

import com.touristguide.features.guides.dto.GuideDto;
import com.touristguide.features.guides.repository.GuideRepository;
import com.touristguide.shared.exception.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class GuideService {

    private final GuideRepository guideRepository;

    /**
     * Retourne tous les guides triés par note décroissante.
     * Correspond à GuidesCubit.fetchGuides() Flutter.
     */
    public List<GuideDto> getAllGuides() {
        return guideRepository.findAllByOrderByRatingDesc()
                .stream()
                .map(GuideDto::fromEntity)
                .toList();
    }

    /**
     * Filtre les guides selon les critères — correspond exactement à
     * GuidesCubit.searchGuides(city, minBudget, maxBudget, language,
     *                          transportAvailable, minRating)
     *
     * Les paramètres null sont ignorés (pas de filtre appliqué).
     */
    public List<GuideDto> searchGuides(
            String city,
            Double minBudget,
            Double maxBudget,
            String language,
            Boolean transportAvailable,
            Double minRating
    ) {
        // Normalisation : "All" dans Flutter = pas de filtre côté backend
        String normalizedCity = (city == null || city.isBlank() || city.equalsIgnoreCase("All"))
                ? null : city;
        String normalizedLang = (language == null || language.isBlank() || language.equalsIgnoreCase("All"))
                ? null : language;

        return guideRepository.findWithFilters(
                        normalizedCity,
                        minBudget,
                        maxBudget,
                        normalizedLang,
                        transportAvailable,
                        minRating
                )
                .stream()
                .map(GuideDto::fromEntity)
                .toList();
    }

    /**
     * Retourne le détail d'un guide par son id.
     * Correspond à la page guide_details_page.dart Flutter.
     */
    public GuideDto getGuideById(Long id) {
        return guideRepository.findById(id)
                .map(GuideDto::fromEntity)
                .orElseThrow(() -> new ResourceNotFoundException("Guide not found with id: " + id));
    }
}
