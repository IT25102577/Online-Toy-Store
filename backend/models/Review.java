package com.toystore.onlinetoystore.model;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
// ENCAPSULATION 
// INHERITANCE 
// POLYMORPHISM 
public class Review {
    private Long id;             
    private Long toyId;          
    private Long userId;         
    private String userName;     
    private Integer rating;      
    private String comment;      
    private String reviewDate;   
    private String status;       
    private Boolean isVerified;  
    //Constructor
    public Review(Long id, Long toyId, Long userId, String userName,
                  Integer rating, String comment, Boolean isVerified) {
        this.id = id;
        this.toyId = toyId;
        this.userId = userId;
        this.userName = userName;
        this.rating = rating;
        this.comment = comment;
        this.reviewDate = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
        this.status = "PENDING";  // Default: needs admin approval
        this.isVerified = isVerified;
    }
    // Empty constructor
    public Review() {}

    
    public Long getId() { return id; }
    public Long getToyId() { return toyId; }
    public Long getUserId() { return userId; }
    public String getUserName() { return userName; }
    public Integer getRating() { return rating; }
    public String getComment() { return comment; }
    public String getReviewDate() { return reviewDate; }
    public String getStatus() { return status; }
    public Boolean getIsVerified() { return isVerified; }

    
    public void setId(Long id) { this.id = id; }
    public void setToyId(Long toyId) { this.toyId = toyId; }
    public void setUserId(Long userId) { this.userId = userId; }
    public void setUserName(String userName) { this.userName = userName; }
    public void setRating(Integer rating) { this.rating = rating; }
    public void setComment(String comment) { this.comment = comment; }
    public void setReviewDate(String reviewDate) { this.reviewDate = reviewDate; }
    public void setStatus(String status) { this.status = status; }
    public void setIsVerified(Boolean isVerified) { this.isVerified = isVerified; }

    public String getStarRating() {
        StringBuilder stars = new StringBuilder();
        for (int i = 1; i <= 5; i++) {
            if (i <= rating) {
                stars.append("★");
            } else {
                stars.append("☆");
            }
        }
        return stars.toString();
    }

    // Get average rating 
    public static double getAverageRating(List<Review> reviews) {
        if (reviews == null || reviews.isEmpty()) return 0;
        double sum = 0;
        for (Review review : reviews) {
            if ("APPROVED".equals(review.getStatus())) {
                sum += review.getRating();
            }
        }
        long approvedCount = reviews.stream().filter(r -> "APPROVED".equals(r.getStatus())).count();
        return approvedCount == 0 ? 0 : sum / approvedCount;
    }

    
    // POLYMORPHISM 
    
    public String getDisplayMessage() {
        if (Boolean.TRUE.equals(isVerified)) {
            return "✓ VERIFIED PURCHASE - " + userName + " says: " + comment;
        } else {
            return userName + " says: " + comment;
        }
    }

   

    // Convert to string for saving to file
    // Format: id|toyId|userId|userName|rating|comment|date|status|isVerified
    public String toFileString() {
        return id + "|" + toyId + "|" + userId + "|" + userName + "|" +
                rating + "|" + comment + "|" + reviewDate + "|" + status + "|" + isVerified;
    }

    // Create Review from file string
    public static Review fromFileString(String line) {
        String[] parts = line.split("\\|");
        Review review = new Review();
        review.setId(Long.parseLong(parts[0]));
        review.setToyId(Long.parseLong(parts[1]));
        review.setUserId(Long.parseLong(parts[2]));
        review.setUserName(parts[3]);
        review.setRating(Integer.parseInt(parts[4]));
        review.setComment(parts[5]);
        review.setReviewDate(parts[6]);
        review.setStatus(parts[7]);
        review.setIsVerified(Boolean.parseBoolean(parts[8]));
        return review;
    }
}


// INHERITANCE EXAMPLE - VerifiedReview extends Review

class VerifiedReview extends Review {
    private String purchaseDate;  // Extra field for verified purchases

    public VerifiedReview(Long id, Long toyId, Long userId, String userName,
                          Integer rating, String comment, String purchaseDate) {
        super(id, toyId, userId, userName, rating, comment, true);
        this.purchaseDate = purchaseDate;
    }

    public String getPurchaseDate() { return purchaseDate; }

    // POLYMORPHISM 
    @Override
    public String getDisplayMessage() {
        return "⭐ VERIFIED (Purchased on " + purchaseDate + "): " + getComment();
    }
}


// INHERITANCE EXAMPLE - NormalReview extends Review

class NormalReview extends Review {
    public NormalReview(Long id, Long toyId, Long userId, String userName,
                        Integer rating, String comment) {
        super(id, toyId, userId, userName, rating, comment, false);
    }

    // POLYMORPHISM 
    @Override
    public String getDisplayMessage() {
        return "📝 UNVERIFIED: " + getComment() + " (Note: This user did not purchase this toy)";
    }
}
