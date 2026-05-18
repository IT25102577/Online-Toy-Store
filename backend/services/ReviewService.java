package com.toystore.onlinetoystore.service;

import com.toystore.onlinetoystore.model.Review;
import com.toystore.onlinetoystore.model.Toy;
import com.toystore.onlinetoystore.model.Order;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.stream.Collectors;


// ABSTRACTION - Complex review operations hidden behind simple methods
@Service
public class ReviewService {

    @Value("${file.reviews}")
    private String reviewsFile;

    private final FileService fileService;
    private final ToyService toyService;
    private final OrderService orderService;

    public ReviewService(FileService fileService, ToyService toyService, OrderService orderService) {
        this.fileService = fileService;
        this.toyService = toyService;
        this.orderService = orderService;
    }
    // CREATE - Add a new review (CRUD - Create)
    /**
     * Add a review for a toy
     * @param toyId 
     * @param userId 
     * @param userName 
     * @param rating 
     * @param comment 
     * @return 
     */
    public Review addReview(Long toyId, Long userId, String userName,
                            Integer rating, String comment) {
        // Validate rating
        if (rating < 1 || rating > 5) {
            return null;
        }

        // Check if toy exists
        Toy toy = toyService.findById(toyId);
        if (toy == null) {
            return null;
        }

        // Check if user already reviewed this toy
        if (hasUserReviewedToy(userId, toyId)) {
            return null;  // Can't review same toy twice
        }

        // Check if user actually purchased this toy (verified review)
        boolean isVerified = hasUserPurchasedToy(userId, toyId);

        // Create new review
        long newId = fileService.getNextId(reviewsFile);
        Review review = new Review(newId, toyId, userId, userName, rating, comment, isVerified);

        // Save to file
        fileService.appendLine(reviewsFile, review.toFileString());

        return review;
    }
    // READ - Get reviews (CRUD - Read)
    /**
     * Get all reviews
     */
    public List<Review> getAllReviews() {
        List<String> lines = fileService.readAllLines(reviewsFile);
        return lines.stream()
                .map(Review::fromFileString)
                .collect(Collectors.toList());
    }

    /**
     * Get reviews for a specific toy (only approved ones for public view)
     */
    public List<Review> getReviewsByToy(Long toyId) {
        return getAllReviews().stream()
                .filter(r -> r.getToyId().equals(toyId))
                .filter(r -> "APPROVED".equals(r.getStatus()))
                .collect(Collectors.toList());
    }

    /**
     * Get ALL reviews for a toy (including pending/rejected - admin only)
     */
    public List<Review> getAllReviewsByToy(Long toyId) {
        return getAllReviews().stream()
                .filter(r -> r.getToyId().equals(toyId))
                .collect(Collectors.toList());
    }

    /**
     * Get reviews by user
     */
    public List<Review> getReviewsByUser(Long userId) {
        return getAllReviews().stream()
                .filter(r -> r.getUserId().equals(userId))
                .collect(Collectors.toList());
    }

    /**
     * Get review by ID
     */
    public Review getReviewById(Long id) {
        return getAllReviews().stream()
                .filter(r -> r.getId().equals(id))
                .findFirst()
                .orElse(null);
    }

    /**
     * Get average rating for a toy
     */
    public double getAverageRatingForToy(Long toyId) {
        List<Review> reviews = getReviewsByToy(toyId);
        return Review.getAverageRating(reviews);
    }

    /**
     * Check if user already reviewed a toy
     */
    public boolean hasUserReviewedToy(Long userId, Long toyId) {
        return getAllReviews().stream()
                .anyMatch(r -> r.getUserId().equals(userId) &&
                        r.getToyId().equals(toyId));
    }

    /**
     * Check if user purchased this toy (for verified badge)
     */
    private boolean hasUserPurchasedToy(Long userId, Long toyId) {
        List<Order> userOrders = orderService.getOrdersByUser(userId);

        for (Order order : userOrders) {
            if ("DELIVERED".equals(order.getStatus())) {
                for (Order.OrderItem item : order.getItems()) {
                    if (item.getToyId().equals(toyId)) {
                        return true;
                    }
                }
            }
        }
        return false;
    }
    

    /**
     * Update a review (user edits their review)
     */
    public boolean updateReview(Long reviewId, Integer rating, String comment) {
        List<Review> reviews = getAllReviews();
        boolean found = false;

        for (int i = 0; i < reviews.size(); i++) {
            if (reviews.get(i).getId().equals(reviewId)) {
                Review r = reviews.get(i);
                if (rating != null && rating >= 1 && rating <= 5) {
                    r.setRating(rating);
                }
                if (comment != null && !comment.isEmpty()) {
                    r.setComment(comment);
                }
                reviews.set(i, r);
                found = true;
                break;
            }
        }

        if (found) {
            saveAllReviews(reviews);
        }
        return found;
    }

    /**
     * Admin approves a review
     */
    public boolean approveReview(Long reviewId) {
        return updateReviewStatus(reviewId, "APPROVED");
    }

    /**
     * Admin rejects a review
     */
    public boolean rejectReview(Long reviewId) {
        return updateReviewStatus(reviewId, "REJECTED");
    }

    /**
     * Update review status (PENDING, APPROVED, REJECTED)
     */
    private boolean updateReviewStatus(Long reviewId, String status) {
        List<Review> reviews = getAllReviews();
        boolean found = false;

        for (int i = 0; i < reviews.size(); i++) {
            if (reviews.get(i).getId().equals(reviewId)) {
                reviews.get(i).setStatus(status);
                found = true;
                break;
            }
        }

        if (found) {
            saveAllReviews(reviews);
        }
        return found;
    }
    // DELETE - Remove review (CRUD - Delete)
    /**
     * Delete a review
     */
    public boolean deleteReview(Long reviewId) {
        List<Review> reviews = getAllReviews();
        boolean removed = reviews.removeIf(r -> r.getId().equals(reviewId));

        if (removed) {
            saveAllReviews(reviews);
        }
        return removed;
    }

    /**
     * Delete all reviews for a toy (when toy is deleted)
     */
    public void deleteReviewsByToy(Long toyId) {
        List<Review> reviews = getAllReviews();
        boolean changed = reviews.removeIf(r -> r.getToyId().equals(toyId));

        if (changed) {
            saveAllReviews(reviews);
        }
    }
    private void saveAllReviews(List<Review> reviews) {
        List<String> lines = reviews.stream()
                .map(Review::toFileString)
                .collect(Collectors.toList());
        fileService.writeAllLines(reviewsFile, lines);
    }
}
