package com.toystore.onlinetoystore.controller;

import com.toystore.onlinetoystore.model.Review;
import com.toystore.onlinetoystore.model.Toy;
import com.toystore.onlinetoystore.model.User;
import com.toystore.onlinetoystore.service.ReviewService;
import com.toystore.onlinetoystore.service.ToyService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class ReviewController {
    private final ReviewService reviewService;
    private final ToyService toyService;

    public ReviewController(ReviewService reviewService, ToyService toyService) {
        this.reviewService = reviewService;
        this.toyService = toyService;
    }

   
    // UI PAGES
    

    /**
     * Show all reviews for a toy (public page)
     */
    @GetMapping("/toys/{toyId}/reviews")
    public String showReviews(@PathVariable Long toyId, Model model) {
        Toy toy = toyService.findById(toyId);
        if (toy == null) {
            return "redirect:/toys";
        }

        List<Review> reviews = reviewService.getReviewsByToy(toyId);
        double averageRating = reviewService.getAverageRatingForToy(toyId);

        model.addAttribute("toy", toy);
        model.addAttribute("reviews", reviews);
        model.addAttribute("averageRating", averageRating);
        model.addAttribute("reviewCount", reviews.size());

        return "reviews";
    }

    /**
     * Show form to submit a review
     */
    @GetMapping("/toys/{toyId}/write-review")
    public String showWriteReview(@PathVariable Long toyId, HttpSession session, Model model) {
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) {
            return "redirect:/login";
        }

        Toy toy = toyService.findById(toyId);
        if (toy == null) {
            return "redirect:/toys";
        }

        // Check if user already reviewed
        if (reviewService.hasUserReviewedToy(user.getId(), toyId)) {
            model.addAttribute("error", "You have already reviewed this toy!");
            return "redirect:/toys/" + toyId + "/reviews";
        }

        model.addAttribute("toy", toy);
        model.addAttribute("user", user);
        return "write-review";
    }

    /**
     * Admin page to moderate pending reviews
     */
    @GetMapping("/admin/reviews")
    public String moderateReviews(HttpSession session, Model model) {
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null || !"ADMIN".equals(user.getRole())) {
            return "redirect:/login";
        }

        List<Review> pendingReviews = reviewService.getAllReviews().stream()
                .filter(r -> "PENDING".equals(r.getStatus()))
                .collect(java.util.stream.Collectors.toList());

        model.addAttribute("pendingReviews", pendingReviews);
        return "admin-reviews";
    }

    
    // REST APIs
    

    /**
     * API - Submit a new review
     * POST /api/reviews
     */
    @PostMapping("/api/reviews")
    @ResponseBody
    public Map<String, Object> submitReview(HttpSession session,
                                            @RequestParam Long toyId,
                                            @RequestParam Integer rating,
                                            @RequestParam String comment) {
        Map<String, Object> response = new HashMap<>();
        User user = (User) session.getAttribute("loggedInUser");

        if (user == null) {
            response.put("success", false);
            response.put("message", "Please login to write a review!");
            return response;
        }

        Review review = reviewService.addReview(toyId, user.getId(), user.getFullName(), rating, comment);

        if (review != null) {
            response.put("success", true);
            response.put("message", "Review submitted! Waiting for admin approval.");
            response.put("review", review);
        } else {
            response.put("success", false);
            response.put("message", "You have already reviewed this toy or invalid rating!");
        }
        return response;
    }

    /**
     * API - Get all reviews for a toy
     * GET /api/reviews/toy/{toyId}
     */
    @GetMapping("/api/reviews/toy/{toyId}")
    @ResponseBody
    public Map<String, Object> getToyReviews(@PathVariable Long toyId) {
        Map<String, Object> response = new HashMap<>();
        List<Review> reviews = reviewService.getReviewsByToy(toyId);
        double averageRating = reviewService.getAverageRatingForToy(toyId);

        response.put("reviews", reviews);
        response.put("averageRating", averageRating);
        response.put("totalReviews", reviews.size());
        return response;
    }

    /**
     * API - Get user's reviews
     * GET /api/reviews/my
     */
    @GetMapping("/api/reviews/my")
    @ResponseBody
    public List<Review> getMyReviews(HttpSession session) {
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) {
            return List.of();
        }
        return reviewService.getReviewsByUser(user.getId());
    }

    /**
     * API - Update a review
     * PUT /api/reviews/{reviewId}
     */
    @PutMapping("/api/reviews/{reviewId}")
    @ResponseBody
    public Map<String, Object> updateReview(HttpSession session,
                                            @PathVariable Long reviewId,
                                            @RequestParam Integer rating,
                                            @RequestParam String comment) {
        Map<String, Object> response = new HashMap<>();
        User user = (User) session.getAttribute("loggedInUser");

        if (user == null) {
            response.put("success", false);
            response.put("message", "Please login!");
            return response;
        }

        boolean updated = reviewService.updateReview(reviewId, rating, comment);

        response.put("success", updated);
        response.put("message", updated ? "Review updated!" : "Review not found!");
        return response;
    }

    /**
     * API - Delete a review
     * DELETE /api/reviews/{reviewId}
     */
    @DeleteMapping("/api/reviews/{reviewId}")
    @ResponseBody
    public Map<String, Object> deleteReview(HttpSession session,
                                            @PathVariable Long reviewId) {
        Map<String, Object> response = new HashMap<>();
        User user = (User) session.getAttribute("loggedInUser");

        if (user == null) {
            response.put("success", false);
            response.put("message", "Please login!");
            return response;
        }

        boolean deleted = reviewService.deleteReview(reviewId);

        response.put("success", deleted);
        response.put("message", deleted ? "Review deleted!" : "Review not found!");
        return response;
    }

    
    // ADMIN APIs
   

    /**
     * API - Admin approves a review
     * POST /api/admin/reviews/{reviewId}/approve
     */
    @PostMapping("/api/admin/reviews/{reviewId}/approve")
    @ResponseBody
    public Map<String, Object> approveReview(HttpSession session, @PathVariable Long reviewId) {
        Map<String, Object> response = new HashMap<>();
        User user = (User) session.getAttribute("loggedInUser");

        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.put("success", false);
            response.put("message", "Unauthorized!");
            return response;
        }

        boolean approved = reviewService.approveReview(reviewId);

        response.put("success", approved);
        response.put("message", approved ? "Review approved!" : "Review not found!");
        return response;
    }

    /**
     * API - Admin rejects a review
     * POST /api/admin/reviews/{reviewId}/reject
     */
    @PostMapping("/api/admin/reviews/{reviewId}/reject")
    @ResponseBody
    public Map<String, Object> rejectReview(HttpSession session, @PathVariable Long reviewId) {
        Map<String, Object> response = new HashMap<>();
        User user = (User) session.getAttribute("loggedInUser");

        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.put("success", false);
            response.put("message", "Unauthorized!");
            return response;
        }

        boolean rejected = reviewService.rejectReview(reviewId);

        response.put("success", rejected);
        response.put("message", rejected ? "Review rejected!" : "Review not found!");
        return response;
    }

    /**
     * API - Admin gets all pending reviews
     * GET /api/admin/reviews/pending
     */
    @GetMapping("/api/admin/reviews/pending")
    @ResponseBody
    public List<Review> getPendingReviews(HttpSession session) {
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null || !"ADMIN".equals(user.getRole())) {
            return List.of();
        }

        return reviewService.getAllReviews().stream()
                .filter(r -> "PENDING".equals(r.getStatus()))
                .collect(java.util.stream.Collectors.toList());
    }
}
