package com.touristguide.features.reviews.controller;

import com.touristguide.features.reviews.dto.CreateReviewRequest;
import com.touristguide.features.reviews.dto.ReviewDto;
import com.touristguide.features.reviews.service.ReviewService;
import com.touristguide.shared.response.ApiResponse;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
public class ReviewController {

    private final ReviewService reviewService;

    /**
     * POST /api/reviews
     * Touriste laisse un avis après un booking COMPLETED
     */
    @PostMapping("/reviews")
    public ResponseEntity<ApiResponse<ReviewDto>> createReview(
            @Valid @RequestBody CreateReviewRequest request,
            @AuthenticationPrincipal UserDetails userDetails) {
        ReviewDto review = reviewService.createReview(request, userDetails.getUsername());
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.ok("Review submitted successfully", review));
    }

    /**
     * GET /api/guides/{guideId}/reviews
     * Liste des avis d'un guide (public)
     */
    @GetMapping("/guides/{guideId}/reviews")
    public ResponseEntity<ApiResponse<List<ReviewDto>>> getGuideReviews(
            @PathVariable Long guideId) {
        return ResponseEntity.ok(ApiResponse.ok(reviewService.getGuideReviews(guideId)));
    }
}
