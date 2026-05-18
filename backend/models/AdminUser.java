package com.toystore.onlinetoystore.model;

public class AdminUser extends User {
    // These are EXTRA fields that only AdminUser has
    // Regular users don't have these!
    private String adminLevel; // "SUPER_ADMIN", "MODERATOR", etc.
    private String department; // "Sales", "Inventory", "Support"

    // Constructor - calls parent constructor using 'super()'
    public AdminUser(Long id, String username, String password, String email,
            String fullName, boolean active, String adminLevel, String department) {
        // super() calls the PARENT (User) constructor
        // This sets id, username, password, email, fullName, role, active
        super(id, username, password, email, fullName, "ADMIN", active);

        // Then set the extra admin-specific fields
        this.adminLevel = adminLevel;
        this.department = department;
    }

    // Empty constructor
    public AdminUser() {
        super();
    }

    // Getters and setters for the extra fields
    public String getAdminLevel() {
        return adminLevel;
    }

    public void setAdminLevel(String adminLevel) {
        this.adminLevel = adminLevel;
    }

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }

    // ============================================
    // POLYMORPHISM DEMONSTRATION - Method Overriding
    // ============================================
    // This method OVERRIDES the one from User class
    // Same method name, DIFFERENT behavior!
    @Override
    public String getRole() {
        return "ADMIN with level: " + adminLevel; // Different output!
    }

    @Override
    public String toFileString() {
        return super.toFileString() + "|" + adminLevel + "|" + department + "|";
    }

    // Create AdminUser from file string
    public static AdminUser fromFileString(String line) {
        String[] parts = line.split("\\|");
        AdminUser admin = new AdminUser();
        admin.setId(Long.parseLong(parts[0]));
        admin.setUsername(parts[1]);
        admin.setPassword(parts[2]);
        admin.setEmail(parts[3]);
        admin.setFullName(parts[4]);
        admin.setRole(parts[5]);
        admin.setActive(Boolean.parseBoolean(parts[6]));

        // Admin-specific fields (if they exist in the file)
        if (parts.length > 7) {
            admin.setAdminLevel(parts[7]);
            admin.setDepartment(parts[8]);

        }
        return admin;
    }
}