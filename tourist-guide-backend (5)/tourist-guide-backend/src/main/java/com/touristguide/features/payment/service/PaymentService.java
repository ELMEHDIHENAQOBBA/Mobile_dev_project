package com.touristguide.features.payment.service;

import com.touristguide.features.booking.model.Booking;
import com.touristguide.features.booking.repository.BookingRepository;
import com.touristguide.features.payment.dto.PaymentDto;
import com.touristguide.features.payment.model.Payment;
import com.touristguide.features.payment.model.PaymentStatus;
import com.touristguide.features.payment.repository.PaymentRepository;
import com.touristguide.shared.exception.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class PaymentService {

    private final PaymentRepository paymentRepository;
    private final BookingRepository bookingRepository;

    // ─── Simuler un paiement pour une réservation ─────────────────────────────

    @Transactional
    public PaymentDto processPayment(Long bookingId, String touristEmail) {
        Booking booking = bookingRepository.findById(bookingId)
                .orElseThrow(() -> new ResourceNotFoundException("Booking not found: " + bookingId));

        // Vérifier que le touriste connecté est bien celui de la réservation
        if (!booking.getTourist().getEmail().equals(touristEmail)) {
            throw new IllegalStateException("Not authorized to pay for this booking");
        }

        // Vérifier qu'il n'y a pas déjà un paiement
        if (paymentRepository.findByBookingId(bookingId).isPresent()) {
            throw new IllegalStateException("Payment already exists for this booking");
        }

        // Simulation du paiement — toujours PAID en MVP
        Payment payment = Payment.builder()
                .booking(booking)
                .amount(booking.getTotalPrice())
                .status(PaymentStatus.PAID)
                .paymentMethod("CARD")
                .transactionRef("TXN-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase())
                .paidAt(LocalDateTime.now())
                .build();

        return PaymentDto.fromEntity(paymentRepository.save(payment));
    }

    // ─── Récupérer le paiement d'une réservation ─────────────────────────────

    public PaymentDto getPaymentByBooking(Long bookingId) {
        return paymentRepository.findByBookingId(bookingId)
                .map(PaymentDto::fromEntity)
                .orElseThrow(() -> new ResourceNotFoundException("No payment found for booking: " + bookingId));
    }

    // ─── Historique des paiements du touriste ────────────────────────────────

    public List<PaymentDto> getMyPayments(String touristEmail) {
        // On récupère l'id du touriste via l'email dans la relation booking
        return paymentRepository.findByBookingTouristIdOrderByCreatedAtDesc(
                        paymentRepository.findAll().stream()
                                .filter(p -> p.getBooking().getTourist().getEmail().equals(touristEmail))
                                .findFirst()
                                .map(p -> p.getBooking().getTourist().getId())
                                .orElse(-1L)
                )
                .stream().map(PaymentDto::fromEntity).toList();
    }
}
