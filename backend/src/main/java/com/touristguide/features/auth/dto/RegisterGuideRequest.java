package com.touristguide.features.auth.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class RegisterGuideRequest {

    @NotBlank(message = "Name is required")
    private String name;

    @NotBlank(message = "Email is required")
    @Email(message = "Invalid email format")
    private String email;

    @NotBlank(message = "Password is required")
    @Size(min = 6, message = "Password must be at least 6 characters")
    private String password;

    @NotBlank(message = "City is required")
    private String city;

    @NotBlank(message = "Description is required")
    private String description;

    @NotNull(message = "Price min is required")
    private Double priceMin;

    @NotNull(message = "Price max is required")
    private Double priceMax;

    private java.util.List<String> languages;

    private Boolean transportAvailable = false;

    private String profileImage;
}
