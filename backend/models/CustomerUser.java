package com.toystore.onlinetoystore.model;


public class CustomerUser extends User {
    private Integer loyaltyPoints;  
    private String wishlist;        

    public CustomerUser(Long id, String username, String password, String email,
                        String fullName, boolean active, Integer loyaltyPoints, String wishlist) {
        super(id, username, password, email, fullName, "CUSTOMER", active);
        this.loyaltyPoints = loyaltyPoints;
        this.wishlist = wishlist;
    }

    public Integer getLoyaltyPoints() { return loyaltyPoints; }
    public void setLoyaltyPoints(Integer loyaltyPoints) { this.loyaltyPoints = loyaltyPoints; }

    public String getWishlist() { return wishlist; }
    public void setWishlist(String wishlist) { this.wishlist = wishlist; }


    @Override
    public String getRole() {
        return "CUSTOMER with " + loyaltyPoints + " points";  
    }
}
