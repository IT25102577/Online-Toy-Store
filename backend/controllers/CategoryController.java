package com.toystore.onlinetoystore.controller;

import com.toystore.onlinetoystore.model.Category;
import com.toystore.onlinetoystore.service.CategoryService;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/categories")
public class CategoryController {
    private final CategoryService categoryService;

    public CategoryController(CategoryService categoryService) {
        this.categoryService = categoryService;
    }

    @PostMapping
    public Map<String, Object> addCategory(@RequestParam String name, @RequestParam String description, @RequestParam(defaultValue = "") String imageUrl) {
        Map<String, Object> response = new HashMap<>();
        Category category = categoryService.addCategory(name, description, imageUrl);
        response.put("success", true);
        response.put("category", category);
        return response;
    }

    @GetMapping
    public List<Category> getAllCategories() {
        return categoryService.getAllCategories();
    }

    @GetMapping("/{id}")
    public Category getCategory(@PathVariable Long id) {
        return categoryService.findById(id);
    }

    @GetMapping("/{id}/toys")
    public List<?> getToysInCategory(@PathVariable Long id) {
        return categoryService.getToysInCategory(id);
    }

    @PutMapping("/{categoryId}/add-toy/{toyId}")
    public Map<String, Object> addToyToCategory(@PathVariable Long categoryId, @PathVariable Long toyId) {
        Map<String, Object> response = new HashMap<>();
        boolean success = categoryService.addToyToCategory(categoryId, toyId);
        response.put("success", success);
        return response;
    }

    @DeleteMapping("/{id}")
    public Map<String, Object> deleteCategory(@PathVariable Long id) {
        Map<String, Object> response = new HashMap<>();
        boolean deleted = categoryService.deleteCategory(id);
        response.put("success", deleted);
        return response;
    }
}
