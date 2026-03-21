package com.touristguide.features.reviews.dto;

import com.touristguide.features.reviews.model.Review;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@Builder
public class ReviewDto {

    private Long id;
    private Long guideId;
    private Long touristId;
    private String touristName;
    private Long bookingId;
    private Integer rating;
    private String comment;
    private LocalDateTime createdAt;

    public static ReviewDto fromEntity(Review review) {
        return ReviewDto.builder()
                .id(review.getId())
                .guideId(review.getGuide().getId())
                .touristId(review.getTourist().getId())
                .touristName(review.getTourist().getName())
                .bookingId(review.getBooking().getId())
                .rating(review.getRating())
                .comment(review.getComment())
                .createdAt(review.getCreatedAt())
                .build();
    }
}
