package com.touristguide.features.guides.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class GuideDashboardDto {
    private GuideDto profile;
    private long totalBookings;
    private long pendingBookings;
    private long confirmedBookings;
    private long completedBookings;
    private double totalEarnings;      // Somme des bookings COMPLETED
    private double averageRating;
    private long totalReviews;
}
