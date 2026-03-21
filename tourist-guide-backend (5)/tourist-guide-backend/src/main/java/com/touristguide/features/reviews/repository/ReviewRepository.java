package com.touristguide.features.reviews.repository;

import com.touristguide.features.reviews.model.Review;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ReviewRepository extends JpaRepository<Review, Long> {

    List<Review> findByGuideIdOrderByCreatedAtDesc(Long guideId);

    Optional<Review> findByTouristIdAndGuideId(Long touristId, Long guideId);

    boolean existsByTouristIdAndGuideId(Long touristId, Long guideId);

    @Query("SELECT AVG(r.rating) FROM Review r WHERE r.guide.id = :guideId")
    Double calculateAverageRating(@Param("guideId") Long guideId);

    long countByGuideId(Long guideId);
}
