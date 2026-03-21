package com.touristguide.features.payment.model;

public enum PaymentStatus {
    PENDING,   // Paiement initié, pas encore confirmé
    PAID,      // Paiement simulé confirmé
    REFUNDED,  // Remboursé suite à annulation
    FAILED     // Échec du paiement
}
