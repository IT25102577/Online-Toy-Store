package com.toystore.onlinetoystore.service;
import com.toystore.onlinetoystore.model.Category;
import com.toystore.onlinetoystore.model.Toy;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.stream.Collectors;

@Service
public class CategoryService {
    @Value("${file.categories}")
    private String categoriesFile;

    private final FileService fileService;
    private final ToyService toyService;

    public CategoryService(FileService fileService, ToyService toyService) {
        this.fileService = fileService;
        this.toyService = toyService;
    }

    // CREATE - Add category
    public Category addCategory(String name, String description, String imageUrl) {
        long newId = fileService.getNextId(categoriesFile);
        Category category = new Category(newId, name, description, imageUrl);
        fileService.appendLine(categoriesFile, category.toFileString());
        return category;
    }

    // READ - Get all categories
    public List<Category> getAllCategories() {
        List<String> lines = fileService.readAllLines(categoriesFile);
        List<Category> categories = lines.stream()
                .map(Category::fromFileString)
                .collect(Collectors.toList());

        // Dynamically sync toyIds from the list of all toys
        List<Toy> allToys = toyService.getAllToys();
        for (Category category : categories) {
            category.getToyIds().clear();
            for (Toy toy : allToys) {
                if (categoryMatches(category.getName(), toy.getCategory())) {
                    category.addToy(toy.getId());
                }
            }
        }
        return categories;
    }

    private boolean categoryMatches(String categoryName, String toyCategoryName) {
        if (categoryName == null || toyCategoryName == null) return false;
        String catLower = categoryName.trim().toLowerCase();
        String toyLower = toyCategoryName.trim().toLowerCase();

        // 1. Exact match
        if (catLower.equals(toyLower)) return true;

        // 2. Toy category is a prefix of category name (e.g. "stuffed" matches "stuffed toys")
        if (catLower.startsWith(toyLower)) return true;

        // 3. Category name is a prefix of toy category (e.g. "puzzle" matches "puzzles")
        if (toyLower.startsWith(catLower)) return true;

        // 4. Singular/Plural handle for vehicles/vehicle, puzzles/puzzle
        if (catLower.endsWith("s") && catLower.substring(0, catLower.length() - 1).equals(toyLower)) return true;
        if (toyLower.endsWith("s") && toyLower.substring(0, toyLower.length() - 1).equals(catLower)) return true;

        // 5. Contains search
        if (catLower.contains(toyLower) || toyLower.contains(catLower)) return true;

        return false;
    }

    // READ - Find category by ID
    public Category findById(Long id) {
        return getAllCategories().stream()
                .filter(c -> c.getId().equals(id))
                .findFirst()
                .orElse(null);
    }

    // READ - Get toys in category
    public List<Toy> getToysInCategory(Long categoryId) {
        Category category = findById(categoryId);
        if (category == null) return List.of();

        return category.getToyIds().stream()
                .map(toyService::findById)
                .filter(Objects::nonNull)
                .collect(Collectors.toList());
    }

    // UPDATE - Add toy to category
    public boolean addToyToCategory(Long categoryId, Long toyId) {
        Category category = findById(categoryId);
        Toy toy = toyService.findById(toyId);

        if (category == null || toy == null) return false;

        category.addToy(toyId);
        return updateCategory(category);
    }

    // UPDATE - Remove toy from category
    public boolean removeToyFromCategory(Long categoryId, Long toyId) {
        Category category = findById(categoryId);
        if (category == null) return false;

        category.removeToy(toyId);
        return updateCategory(category);
    }

    // UPDATE - Update category
    public boolean updateCategory(Category updatedCategory) {
        List<Category> categories = getAllCategories();
        boolean found = false;

        for (int i = 0; i < categories.size(); i++) {
            if (categories.get(i).getId().equals(updatedCategory.getId())) {
                categories.set(i, updatedCategory);
                found = true;
                break;
            }
        }

        if (found) {
            saveAllCategories(categories);
        }
        return found;
    }

    // DELETE - Remove category
    public boolean deleteCategory(Long id) {
        List<Category> categories = getAllCategories();
        Category catToDelete = categories.stream().filter(c -> c.getId().equals(id)).findFirst().orElse(null);
        
        if (catToDelete != null) {
            // Remove this category from all toys that have this category
            List<Toy> allToys = toyService.getAllToys();
            for (Toy toy : allToys) {
                if (categoryMatches(catToDelete.getName(), toy.getCategory())) {
                    toyService.updateToy(toy.getId(), null, null, null, null, null, ""); // Set category to empty string
                }
            }
        }
        
        boolean removed = categories.removeIf(c -> c.getId().equals(id));

        if (removed) {
            saveAllCategories(categories);
        }
        return removed;
    }

    private void saveAllCategories(List<Category> categories) {
        List<String> lines = categories.stream()
                .map(Category::toFileString)
                .collect(Collectors.toList());
        fileService.writeAllLines(categoriesFile, lines);
    }
}
