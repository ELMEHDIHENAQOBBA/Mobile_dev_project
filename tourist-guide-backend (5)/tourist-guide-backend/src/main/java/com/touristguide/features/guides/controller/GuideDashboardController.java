package com.touristguide.features.guides.controller;

import com.touristguide.features.guides.dto.GuideDashboardDto;
import com.touristguide.features.guides.service.GuideDashboardService;
import com.touristguide.shared.response.ApiResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/guide")
@RequiredArgsConstructor
public class GuideDashboardController {

    private final GuideDashboardService dashboardService;

    /**
     * GET /api/guide/dashboard
     * Guide connecté voit ses stats : bookings, gains, rating
     */
    @GetMapping("/dashboard")
    public ResponseEntity<ApiResponse<GuideDashboardDto>> getDashboard(
            @AuthenticationPrincipal UserDetails userDetails) {
        return ResponseEntity.ok(ApiResponse.ok(
                dashboardService.getDashboard(userDetails.getUsername())));
    }
}
