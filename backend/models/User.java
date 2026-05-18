package com.toystore.onlinetoystore.model;
public class User {

    private Long id;           
    private String username;   
    private String password;   
    private String email;     
    private String fullName;   
    private String role;      
    private boolean active;    

    public User(Long id, String username, String password, String email,
                String fullName, String role, boolean active) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.email = email;
        this.fullName = fullName;
        this.role = role;
        this.active = active;
    }

    public User() {}

    public Long getId() {
        return id;
    }

    public String getUsername() {
        return username;
    }

    public String getPassword() {
        return password;
    }

    public String getEmail() {
        return email;
    }

    public String getFullName() {
        return fullName;
    }

    public String getRole() {
        return role;
    }

    public boolean isActive() {
        return active;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public void setActive(boolean active) {
        this.active = active;
    }


    // Convert User object to a string for saving to text file

    public String toFileString() {
        return id + "|" + username + "|" + password + "|" + email + "|" +
                fullName + "|" + role + "|" + active;
    }

    // Create a User object from a string read from text file
    // This is the reverse of toFileString()

    public static User fromFileString(String line) {
        String[] parts = line.split("\\|");

        // Create and return a new User with the extracted values
        return new User(
                Long.parseLong(parts[0]), 
                parts[1],                
                parts[2],               
                parts[3],              
                parts[4],               
                parts[5],                  
                Boolean.parseBoolean(parts[6])
        );
    }
}
