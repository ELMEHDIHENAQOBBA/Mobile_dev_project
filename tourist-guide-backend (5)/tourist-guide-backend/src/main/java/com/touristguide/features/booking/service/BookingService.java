package com.touristguide.features.booking.service;

import com.touristguide.features.auth.model.AppUser;
import com.touristguide.features.auth.repository.UserRepository;
import com.touristguide.features.booking.dto.BookingDto;
import com.touristguide.features.booking.dto.CreateBookingRequest;
import com.touristguide.features.booking.dto.UpdateBookingStatusRequest;
import com.touristguide.features.booking.model.Booking;
import com.touristguide.features.booking.model.BookingStatus;
import com.touristguide.features.booking.repository.BookingRepository;
import com.touristguide.features.guides.model.Guide;
import com.touristguide.features.guides.repository.GuideRepository;
import com.touristguide.shared.exception.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class BookingService {

    private final BookingRepository bookingRepository;
    private final GuideRepository guideRepository;
    private final UserRepository userRepository;

    // ─── Créer une réservation (touriste) ────────────────────────────────────

    @Transactional
    public BookingDto createBooking(CreateBookingRequest request, String touristEmail) {
        AppUser tourist = userRepository.findByEmail(touristEmail)
                .orElseThrow(() -> new ResourceNotFoundException("Tourist not found"));

        Guide guide = guideRepository.findById(request.getGuideId())
                .orElseThrow(() -> new ResourceNotFoundException("Guide not found with id: " + request.getGuideId()));

        // Prix total = priceMin du guide × durée × nombre de personnes
        double totalPrice = guide.getPriceMin() * request.getDurationHours() * request.getNumberOfPeople();

        Booking booking = Booking.builder()
                .tourist(tourist)
                .guide(guide)
                .visitDate(request.getVisitDate())
                .durationHours(request.getDurationHours())
                .numberOfPeople(request.getNumberOfPeople())
                .specialRequest(request.getSpecialRequest())
                .totalPrice(totalPrice)
                .status(BookingStatus.PENDING)
                .build();

        return BookingDto.fromEntity(bookingRepository.save(booking));
    }

    // ─── Mes réservations (touriste) ──────────────────────────────────────────

    public List<BookingDto> getMyBookingsAsTourist(String touristEmail) {
        AppUser tourist = userRepository.findByEmail(touristEmail)
                .orElseThrow(() -> new ResourceNotFoundException("Tourist not found"));
        return bookingRepository.findByTouristIdOrderByCreatedAtDesc(tourist.getId())
                .stream().map(BookingDto::fromEntity).toList();
    }

    // ─── Réservations reçues (guide) ──────────────────────────────────────────

    public List<BookingDto> getIncomingBookingsAsGuide(String guideEmail) {
        AppUser user = userRepository.findByEmail(guideEmail)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));
        Guide guide = guideRepository.findByUserId(user.getId())
                .orElseThrow(() -> new ResourceNotFoundException("Guide profile not found"));
        return bookingRepository.findByGuideIdOrderByCreatedAtDesc(guide.getId())
                .stream().map(BookingDto::fromEntity).toList();
    }

    // ─── Changer le statut (touriste ou guide) ────────────────────────────────

    @Transactional
    public BookingDto updateStatus(Long bookingId, UpdateBookingStatusRequest request, String userEmail) {
        Booking booking = bookingRepository.findById(bookingId)
                .orElseThrow(() -> new ResourceNotFoundException("Booking not found with id: " + bookingId));

        BookingStatus newStatus = request.getStatus();

        // Valider les transitions autorisées
        validateStatusTransition(booking.getStatus(), newStatus);

        booking.setStatus(newStatus);

        if (newStatus == BookingStatus.CANCELLED) {
            // Déterminer qui annule
            boolean isTourist = booking.getTourist().getEmail().equals(userEmail);
            booking.setCancelledBy(isTourist ? "TOURIST" : "GUIDE");
            booking.setCancellationReason(request.getCancellationReason());
        }

        return BookingDto.fromEntity(bookingRepository.save(booking));
    }

    // ─── Détail d'une réservation ─────────────────────────────────────────────

    public BookingDto getBookingById(Long id) {
        return bookingRepository.findById(id)
                .map(BookingDto::fromEntity)
                .orElseThrow(() -> new ResourceNotFoundException("Booking not found with id: " + id));
    }

    // ─── Vérifier si un touriste peut laisser un avis ─────────────────────────

    public boolean canLeaveReview(Long touristId, Long guideId) {
        return bookingRepository.existsByTouristIdAndGuideIdAndStatus(
                touristId, guideId, BookingStatus.COMPLETED);
    }

    // ─── Validation des transitions de statut ─────────────────────────────────

    private void validateStatusTransition(BookingStatus current, BookingStatus next) {
        boolean valid = switch (current) {
            case PENDING -> next == BookingStatus.CONFIRMED || next == BookingStatus.CANCELLED;
            case CONFIRMED -> next == BookingStatus.COMPLETED || next == BookingStatus.CANCELLED;
            case COMPLETED, CANCELLED -> false; // États finaux
        };
        if (!valid) {
            throw new IllegalStateException(
                    "Cannot transition from " + current + " to " + next);
        }
    }
}
