package com.touristguide.features.booking.model;

/**
 * Cycle de vie d'une réservation (flow Uber-like) :
 *
 *  PENDING ──(guide confirme)──► CONFIRMED ──(service terminé)──► COMPLETED
 *     │                              │
 *     └──(touriste ou guide annule)──┴──► CANCELLED
 */
public enum BookingStatus {
    PENDING,     // Touriste vient de réserver, attente confirmation guide
    CONFIRMED,   // Guide a accepté
    COMPLETED,   // Service terminé — débloque la possibilité de laisser un avis
    CANCELLED    // Annulé par l'une des deux parties
}
