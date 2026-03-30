package com.touristguide.features.guides.repository;

import com.touristguide.features.guides.model.Guide;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface GuideRepository extends JpaRepository<Guide, Long> {

    @Query("""
        SELECT DISTINCT g FROM Guide g
        LEFT JOIN g.languages lang
        WHERE
            (:city IS NULL OR LOWER(g.city) = LOWER(:city))
            AND (:minBudget IS NULL OR g.priceMax >= :minBudget)
            AND (:maxBudget IS NULL OR g.priceMin <= :maxBudget)
            AND (:language IS NULL OR :language MEMBER OF g.languages)
            AND (:transportAvailable IS NULL OR g.transportAvailable = :transportAvailable)
            AND (:minRating IS NULL OR g.rating >= :minRating)
        ORDER BY g.rating DESC
    """)
    List<Guide> findWithFilters(
            @Param("city") String city,
            @Param("minBudget") Double minBudget,
            @Param("maxBudget") Double maxBudget,
            @Param("language") String language,
            @Param("transportAvailable") Boolean transportAvailable,
            @Param("minRating") Double minRating
    );

    List<Guide> findAllByOrderByRatingDesc();

    // Nécessaire pour le dashboard guide (lier un user à son profil guide)
    Optional<Guide> findByUserId(Long userId);
}
