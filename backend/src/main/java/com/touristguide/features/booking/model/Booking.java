package com.touristguide.features.booking.model;

import com.touristguide.features.auth.model.AppUser;
import com.touristguide.features.guides.model.Guide;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "bookings")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Booking {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // ─── Qui réserve qui ─────────────────────────────────────────────────────
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "tourist_id", nullable = false)
    private AppUser tourist;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "guide_id", nullable = false)
    private Guide guide;

    // ─── Détails de la réservation ────────────────────────────────────────────
    @Column(name = "visit_date", nullable = false)
    private LocalDate visitDate;

    @Column(name = "duration_hours", nullable = false)
    private Integer durationHours;

    @Column(name = "number_of_people", nullable = false)
    @Builder.Default
    private Integer numberOfPeople = 1;

    @Column(name = "special_request", columnDefinition = "TEXT")
    private String specialRequest;

    // ─── Prix total calculé au moment de la réservation ──────────────────────
    @Column(name = "total_price", nullable = false)
    private Double totalPrice;

    // ─── Statut (flow Uber-like) ──────────────────────────────────────────────
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    @Builder.Default
    private BookingStatus status = BookingStatus.PENDING;

    // ─── Qui a annulé (si CANCELLED) ─────────────────────────────────────────
    @Column(name = "cancelled_by")
    private String cancelledBy; // "TOURIST" ou "GUIDE"

    @Column(name = "cancellation_reason")
    private String cancellationReason;

    // ─── Timestamps ───────────────────────────────────────────────────────────
    @Column(name = "created_at", nullable = false, updatable = false)
    @Builder.Default
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(name = "updated_at")
    @Builder.Default
    private LocalDateTime updatedAt = LocalDateTime.now();

    @PreUpdate
    public void preUpdate() {
        this.updatedAt = LocalDateTime.now();
    }
}
