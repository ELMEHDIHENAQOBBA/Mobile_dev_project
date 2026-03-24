package com.touristguide.features.payment.controller;

import com.touristguide.features.payment.dto.PaymentDto;
import com.touristguide.features.payment.service.PaymentService;
import com.touristguide.shared.response.ApiResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/payments")
@RequiredArgsConstructor
public class PaymentController {

    private final PaymentService paymentService;

    /**
     * POST /api/payments/booking/{bookingId}
     * Touriste simule le paiement d'une réservation confirmée
     */
    @PostMapping("/booking/{bookingId}")
    public ResponseEntity<ApiResponse<PaymentDto>> processPayment(
            @PathVariable Long bookingId,
            @AuthenticationPrincipal UserDetails userDetails) {
        PaymentDto payment = paymentService.processPayment(bookingId, userDetails.getUsername());
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.ok("Payment processed successfully", payment));
    }

    /**
     * GET /api/payments/booking/{bookingId}
     * Récupère le paiement lié à une réservation
     */
    @GetMapping("/booking/{bookingId}")
    public ResponseEntity<ApiResponse<PaymentDto>> getPaymentByBooking(@PathVariable Long bookingId) {
        return ResponseEntity.ok(ApiResponse.ok(paymentService.getPaymentByBooking(bookingId)));
    }

    /**
     * GET /api/payments/me
     * Historique des paiements du touriste connecté
     */
    @GetMapping("/me")
    public ResponseEntity<ApiResponse<List<PaymentDto>>> getMyPayments(
            @AuthenticationPrincipal UserDetails userDetails) {
        return ResponseEntity.ok(ApiResponse.ok(
                paymentService.getMyPayments(userDetails.getUsername())));
    }
}
