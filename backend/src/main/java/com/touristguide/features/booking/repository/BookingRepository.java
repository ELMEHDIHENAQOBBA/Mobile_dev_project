package com.touristguide.features.booking.repository;

import com.touristguide.features.booking.model.Booking;
import com.touristguide.features.booking.model.BookingStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BookingRepository extends JpaRepository<Booking, Long> {

    // Réservations du touriste connecté
    List<Booking> findByTouristIdOrderByCreatedAtDesc(Long touristId);

    // Réservations reçues par un guide
    List<Booking> findByGuideIdOrderByCreatedAtDesc(Long guideId);

    // Réservations par statut pour un guide
    List<Booking> findByGuideIdAndStatusOrderByCreatedAtDesc(Long guideId, BookingStatus status);

    // Vérifier si un touriste a déjà un booking completed avec ce guide (pour autoriser le review)
    boolean existsByTouristIdAndGuideIdAndStatus(Long touristId, Long guideId, BookingStatus status);
}
