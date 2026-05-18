package com.toystore.onlinetoystore.model;

import java.util.*;
// INHERITANCE + ENCAPSULATION
public class Category {

    private Long id;
    private String name;
    private String description;
    private String imageUrl;  // Category display image
    private List<Long> toyIds;  // Toys in this category

    public Category(Long id, String name, String description) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.imageUrl = "";
        this.toyIds = new ArrayList<>();
    }

    public Category(Long id, String name, String description, String imageUrl) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.imageUrl = imageUrl != null ? imageUrl : "";
        this.toyIds = new ArrayList<>();
    }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public List<Long> getToyIds() { return toyIds; }
    public void setToyIds(List<Long> toyIds) { this.toyIds = toyIds; }

    public void addToy(Long toyId) { toyIds.add(toyId); }
    public void removeToy(Long toyId) { toyIds.remove(toyId); }

    // File storage
    public String toFileString() {
        StringBuilder sb = new StringBuilder();
        sb.append(id).append("|");
        sb.append(name).append("|");
        sb.append(description).append("|");
        sb.append(imageUrl != null ? imageUrl : "").append("|");

        for (int i = 0; i < toyIds.size(); i++) {
            if (i > 0) sb.append(",");
            sb.append(toyIds.get(i));
        }
        return sb.toString();
    }

    public static Category fromFileString(String line) {
        String[] parts = line.split("\\|", -1);
        Category category = new Category(
                Long.parseLong(parts[0]),
                parts[1],
                parts[2]
        );

        // parts[3] = imageUrl (new field), parts[4] = toyIds
        if (parts.length > 3) {
            category.setImageUrl(parts[3]);
        }
        if (parts.length > 4 && !parts[4].isEmpty()) {
            String[] toyIdStrs = parts[4].split(",");
            for (String idStr : toyIdStrs) {
                if (!idStr.isEmpty()) category.addToy(Long.parseLong(idStr));
            }
        } else if (parts.length == 4 && !parts[3].isEmpty()) {
            // Legacy format: parts[3] may be toyIds (no imageUrl field yet)
            try {
                String[] toyIdStrs = parts[3].split(",");
                for (String idStr : toyIdStrs) {
                    if (!idStr.isEmpty()) category.addToy(Long.parseLong(idStr));
                }
                category.setImageUrl(""); // no image in old format
            } catch (NumberFormatException e) {
                // parts[3] is imageUrl in new format, no toyIds
            }
        }
        return category;
    }
}

// ============================================
// INHERITANCE EXAMPLE - Specialized Categories
// ============================================

class IndoorToys extends Category {
    private String roomType;  // "Bedroom", "Playroom", etc.
    private boolean requiresAssembly;

    public IndoorToys(Long id, String name, String description, String roomType, boolean requiresAssembly) {
        super(id, name, description);
        this.roomType = roomType;
        this.requiresAssembly = requiresAssembly;
    }

    public String getRoomType() { return roomType; }
    public boolean isRequiresAssembly() { return requiresAssembly; }
}

class OutdoorToys extends Category {
    private String weatherResistance;  // "Waterproof", "UV Resistant", etc.
    private String recommendedAge;

    public OutdoorToys(Long id, String name, String description, String weatherResistance, String recommendedAge) {
        super(id, name, description);
        this.weatherResistance = weatherResistance;
        this.recommendedAge = recommendedAge;
    }

    public String getWeatherResistance() { return weatherResistance; }
    public String getRecommendedAge() { return recommendedAge; }
}
