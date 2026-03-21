package com.touristguide.features.booking.dto;

import com.touristguide.features.booking.model.BookingStatus;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class UpdateBookingStatusRequest {

    @NotNull(message = "Status is required")
    private BookingStatus status;

    private String cancellationReason;
}
