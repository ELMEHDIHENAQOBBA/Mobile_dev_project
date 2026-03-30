package com.touristguide.features.payment.dto;

import com.touristguide.features.payment.model.Payment;
import com.touristguide.features.payment.model.PaymentStatus;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@Builder
public class PaymentDto {

    private Long id;
    private Long bookingId;
    private Double amount;
    private PaymentStatus status;
    private String paymentMethod;
    private String transactionRef;
    private LocalDateTime createdAt;
    private LocalDateTime paidAt;

    public static PaymentDto fromEntity(Payment payment) {
        return PaymentDto.builder()
                .id(payment.getId())
                .bookingId(payment.getBooking().getId())
                .amount(payment.getAmount())
                .status(payment.getStatus())
                .paymentMethod(payment.getPaymentMethod())
                .transactionRef(payment.getTransactionRef())
                .createdAt(payment.getCreatedAt())
                .paidAt(payment.getPaidAt())
                .build();
    }
}
