package com.touristguide.features.reviews.service;

import com.touristguide.features.auth.model.AppUser;
import com.touristguide.features.auth.repository.UserRepository;
import com.touristguide.features.booking.model.Booking;
import com.touristguide.features.booking.model.BookingStatus;
import com.touristguide.features.booking.repository.BookingRepository;
import com.touristguide.features.guides.model.Guide;
import com.touristguide.features.guides.repository.GuideRepository;
import com.touristguide.features.reviews.dto.CreateReviewRequest;
import com.touristguide.features.reviews.dto.ReviewDto;
import com.touristguide.features.reviews.model.Review;
import com.touristguide.features.reviews.repository.ReviewRepository;
import com.touristguide.shared.exception.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ReviewService {

    private final ReviewRepository reviewRepository;
    private final BookingRepository bookingRepository;
    private final GuideRepository guideRepository;
    private final UserRepository userRepository;

    @Transactional
    public ReviewDto createReview(CreateReviewRequest request, String touristEmail) {
        AppUser tourist = userRepository.findByEmail(touristEmail)
                .orElseThrow(() -> new ResourceNotFoundException("Tourist not found"));
        Guide guide = guideRepository.findById(request.getGuideId())
                .orElseThrow(() -> new ResourceNotFoundException("Guide not found"));
        Booking booking = bookingRepository.findById(request.getBookingId())
                .orElseThrow(() -> new ResourceNotFoundException("Booking not found"));

        if (booking.getStatus() != BookingStatus.COMPLETED)
            throw new IllegalStateException("Can only review a completed booking");
        if (!booking.getTourist().getId().equals(tourist.getId()))
            throw new IllegalStateException("Not authorized to review this booking");
        if (reviewRepository.existsByTouristIdAndGuideId(tourist.getId(), guide.getId()))
            throw new IllegalStateException("You have already reviewed this guide");

        Review saved = reviewRepository.save(Review.builder()
                .tourist(tourist).guide(guide).booking(booking)
                .rating(request.getRating()).comment(request.getComment())
                .build());

        // Recalcul automatique rating + reviewsCount du guide
        Double avg = reviewRepository.calculateAverageRating(guide.getId());
        long count = reviewRepository.countByGuideId(guide.getId());
        guide.setRating(avg != null ? Math.round(avg * 10.0) / 10.0 : 0.0);
        guide.setReviewsCount((int) count);
        guideRepository.save(guide);

        return ReviewDto.fromEntity(saved);
    }

    public List<ReviewDto> getGuideReviews(Long guideId) {
        return reviewRepository.findByGuideIdOrderByCreatedAtDesc(guideId)
                .stream().map(ReviewDto::fromEntity).toList();
    }
}
