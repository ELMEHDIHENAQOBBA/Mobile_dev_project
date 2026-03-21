package com.touristguide.features.booking.controller;

import com.touristguide.features.booking.dto.BookingDto;
import com.touristguide.features.booking.dto.CreateBookingRequest;
import com.touristguide.features.booking.dto.UpdateBookingStatusRequest;
import com.touristguide.features.booking.service.BookingService;
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
@RequestMapping("/api/bookings")
@RequiredArgsConstructor
public class BookingController {

    private final BookingService bookingService;

    /**
     * POST /api/bookings
     * Touriste crée une réservation
     */
    @PostMapping
    public ResponseEntity<ApiResponse<BookingDto>> createBooking(
            @Valid @RequestBody CreateBookingRequest request,
            @AuthenticationPrincipal UserDetails userDetails) {
        BookingDto booking = bookingService.createBooking(request, userDetails.getUsername());
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.ok("Booking created successfully", booking));
    }

    /**
     * GET /api/bookings/me
     * Touriste voit ses réservations
     */
    @GetMapping("/me")
    public ResponseEntity<ApiResponse<List<BookingDto>>> getMyBookings(
            @AuthenticationPrincipal UserDetails userDetails) {
        return ResponseEntity.ok(ApiResponse.ok(
                bookingService.getMyBookingsAsTourist(userDetails.getUsername())));
    }

    /**
     * GET /api/bookings/incoming
     * Guide voit les réservations qu'il a reçues
     */
    @GetMapping("/incoming")
    public ResponseEntity<ApiResponse<List<BookingDto>>> getIncomingBookings(
            @AuthenticationPrincipal UserDetails userDetails) {
        return ResponseEntity.ok(ApiResponse.ok(
                bookingService.getIncomingBookingsAsGuide(userDetails.getUsername())));
    }

    /**
     * GET /api/bookings/{id}
     * Détail d'une réservation
     */
    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<BookingDto>> getBookingById(@PathVariable Long id) {
        return ResponseEntity.ok(ApiResponse.ok(bookingService.getBookingById(id)));
    }

    /**
     * PATCH /api/bookings/{id}/status
     * Changer le statut (touriste ou guide)
     * PENDING → CONFIRMED (guide)
     * CONFIRMED → COMPLETED (guide)
     * PENDING/CONFIRMED → CANCELLED (les deux)
     */
    @PatchMapping("/{id}/status")
    public ResponseEntity<ApiResponse<BookingDto>> updateStatus(
            @PathVariable Long id,
            @Valid @RequestBody UpdateBookingStatusRequest request,
            @AuthenticationPrincipal UserDetails userDetails) {
        BookingDto booking = bookingService.updateStatus(id, request, userDetails.getUsername());
        return ResponseEntity.ok(ApiResponse.ok("Status updated", booking));
    }
}
