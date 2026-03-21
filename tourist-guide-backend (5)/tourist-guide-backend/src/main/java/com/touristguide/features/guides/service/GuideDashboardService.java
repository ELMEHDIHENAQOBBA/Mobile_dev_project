package com.touristguide.features.guides.service;

import com.touristguide.features.auth.model.AppUser;
import com.touristguide.features.auth.repository.UserRepository;
import com.touristguide.features.booking.model.Booking;
import com.touristguide.features.booking.model.BookingStatus;
import com.touristguide.features.booking.repository.BookingRepository;
import com.touristguide.features.guides.dto.GuideDashboardDto;
import com.touristguide.features.guides.dto.GuideDto;
import com.touristguide.features.guides.model.Guide;
import com.touristguide.features.guides.repository.GuideRepository;
import com.touristguide.features.reviews.repository.ReviewRepository;
import com.touristguide.shared.exception.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class GuideDashboardService {

    private final GuideRepository guideRepository;
    private final UserRepository userRepository;
    private final BookingRepository bookingRepository;
    private final ReviewRepository reviewRepository;

    public GuideDashboardDto getDashboard(String guideEmail) {
        AppUser user = userRepository.findByEmail(guideEmail)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));
        Guide guide = guideRepository.findByUserId(user.getId())
                .orElseThrow(() -> new ResourceNotFoundException("Guide profile not found"));

        List<Booking> allBookings = bookingRepository.findByGuideIdOrderByCreatedAtDesc(guide.getId());

        long pending   = allBookings.stream().filter(b -> b.getStatus() == BookingStatus.PENDING).count();
        long confirmed = allBookings.stream().filter(b -> b.getStatus() == BookingStatus.CONFIRMED).count();
        long completed = allBookings.stream().filter(b -> b.getStatus() == BookingStatus.COMPLETED).count();

        double earnings = allBookings.stream()
                .filter(b -> b.getStatus() == BookingStatus.COMPLETED)
                .mapToDouble(Booking::getTotalPrice)
                .sum();

        Double avgRating = reviewRepository.calculateAverageRating(guide.getId());
        long reviewCount = reviewRepository.countByGuideId(guide.getId());

        return GuideDashboardDto.builder()
                .profile(GuideDto.fromEntity(guide))
                .totalBookings(allBookings.size())
                .pendingBookings(pending)
                .confirmedBookings(confirmed)
                .completedBookings(completed)
                .totalEarnings(earnings)
                .averageRating(avgRating != null ? avgRating : 0.0)
                .totalReviews(reviewCount)
                .build();
    }
}
