package com.touristguide.features.guides.controller;

import com.touristguide.features.guides.dto.GuideDto;
import com.touristguide.features.guides.service.GuideService;
import com.touristguide.shared.response.ApiResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/guides")
@RequiredArgsConstructor
public class GuideController {

    private final GuideService guideService;

    /**
     * GET /api/guides
     * Sans paramètres → tous les guides (correspond à fetchGuides())
     * Avec paramètres → filtrage (correspond à searchGuides())
     *
     * Paramètres optionnels (tous alignés sur GuidesCubit) :
     *   ?city=Marrakech
     *   ?minBudget=200&maxBudget=800
     *   ?language=English
     *   ?transportAvailable=true
     *   ?minRating=4.5
     */
    @GetMapping
    public ResponseEntity<ApiResponse<List<GuideDto>>> getGuides(
            @RequestParam(required = false) String city,
            @RequestParam(required = false) Double minBudget,
            @RequestParam(required = false) Double maxBudget,
            @RequestParam(required = false) String language,
            @RequestParam(required = false) Boolean transportAvailable,
            @RequestParam(required = false) Double minRating
    ) {
        boolean hasFilter = city != null || minBudget != null || maxBudget != null
                || language != null || transportAvailable != null || minRating != null;

        List<GuideDto> guides = hasFilter
                ? guideService.searchGuides(city, minBudget, maxBudget, language, transportAvailable, minRating)
                : guideService.getAllGuides();

        return ResponseEntity.ok(ApiResponse.ok(guides));
    }

    /**
     * GET /api/guides/{id}
     * Correspond à la page guide_details_page.dart Flutter
     */
    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<GuideDto>> getGuideById(@PathVariable Long id) {
        return ResponseEntity.ok(ApiResponse.ok(guideService.getGuideById(id)));
    }
}
