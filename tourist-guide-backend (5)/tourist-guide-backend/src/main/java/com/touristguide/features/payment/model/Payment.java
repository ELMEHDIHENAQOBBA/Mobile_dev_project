package com.touristguide.features.payment.model;

import com.touristguide.features.booking.model.Booking;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

/**
 * Paiement simulé (MVP) — lié 1:1 à une réservation.
 * Logique : le paiement est créé automatiquement quand le guide
 * confirme la réservation (status CONFIRMED). Le touriste "paie"
 * avant que le service commence.
 */
@Entity
@Table(name = "payments")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Payment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "booking_id", nullable = false, unique = true)
    private Booking booking;

    @Column(nullable = false)
    private Double amount;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    @Builder.Default
    private PaymentStatus status = PaymentStatus.PENDING;

    // Méthode de paiement simulée
    @Column(name = "payment_method")
    @Builder.Default
    private String paymentMethod = "CARD";

    // Référence unique de transaction (simulée)
    @Column(name = "transaction_ref", unique = true)
    private String transactionRef;

    @Column(name = "created_at", nullable = false, updatable = false)
    @Builder.Default
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(name = "paid_at")
    private LocalDateTime paidAt;
}
