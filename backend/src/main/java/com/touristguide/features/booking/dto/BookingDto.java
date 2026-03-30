package com.touristguide.features.booking.dto;

import com.touristguide.features.booking.model.Booking;
import com.touristguide.features.booking.model.BookingStatus;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@Builder
public class BookingDto {

    private Long id;
    private Long guideId;
    private String guideName;
    private String guideProfileImage;
    private String guideCity;
    private Long touristId;
    private String touristName;
    private LocalDate visitDate;
    private Integer durationHours;
    private Integer numberOfPeople;
    private String specialRequest;
    private Double totalPrice;
    private BookingStatus status;
    private String cancelledBy;
    private String cancellationReason;
    private LocalDateTime createdAt;

    public static BookingDto fromEntity(Booking booking) {
        return BookingDto.builder()
                .id(booking.getId())
                .guideId(booking.getGuide().getId())
                .guideName(booking.getGuide().getName())
                .guideProfileImage(booking.getGuide().getProfileImage())
                .guideCity(booking.getGuide().getCity())
                .touristId(booking.getTourist().getId())
                .touristName(booking.getTourist().getName())
                .visitDate(booking.getVisitDate())
                .durationHours(booking.getDurationHours())
                .numberOfPeople(booking.getNumberOfPeople())
                .specialRequest(booking.getSpecialRequest())
                .totalPrice(booking.getTotalPrice())
                .status(booking.getStatus())
                .cancelledBy(booking.getCancelledBy())
                .cancellationReason(booking.getCancellationReason())
                .createdAt(booking.getCreatedAt())
                .build();
    }
}
