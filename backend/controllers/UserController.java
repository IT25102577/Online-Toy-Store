package com.toystore.onlinetoystore.controller;
import com.toystore.onlinetoystore.model.User;
import com.toystore.onlinetoystore.service.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

// @Controller - This class handles web requests
// They receive requests, call services, and return responses
@Controller
public class UserController {
    private final UserService userService;

    // Spring automatically provides UserService (Dependency Injection)
    public UserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/")
    public String home() {
        return "index";  
    }

    @GetMapping("/register")
    public String showRegister() {
        return "register";  
    }

    @GetMapping("/login")
    public String showLogin() {
        return "login"; 
    }

    @GetMapping("/profile")
    public String showProfile(HttpSession session, Model model) {
        // Get the logged-in user from session
        User user = (User) session.getAttribute("loggedInUser");

        if (user == null) {
            return "redirect:/login";
        }

        model.addAttribute("user", user);
        return "profile";
    }

    /**
     * API: Register a new user
     */
    @PostMapping("/api/register")
    @ResponseBody
    public Map<String, Object> register(@RequestParam String username,
                                        @RequestParam String password,
                                        @RequestParam String email,
                                        @RequestParam String fullName) {
        Map<String, Object> response = new HashMap<>();
        
        if (email == null || !email.trim().toLowerCase().endsWith("@gmail.com")) {
            response.put("success", false);
            response.put("message", "Email must be a valid @gmail.com address");
            return response;
        }

        User user = userService.register(username, password, email, fullName);

        if (user != null) {
            response.put("success", true);
            response.put("message", "Registration successful! Please login.");
            response.put("user", user);
        } else {
            response.put("success", false);
            response.put("message", "Username already exists!");
        }
        return response;  
    }

    /**
     * API: Login user
     */
    @PostMapping("/api/login")
    @ResponseBody
    public Map<String, Object> login(@RequestParam String username,
                                     @RequestParam String password,
                                     HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        User user = userService.login(username, password);

        if (user != null) {
            session.setAttribute("loggedInUser", user);
            response.put("success", true);
            response.put("message", "Login successful!");
            response.put("role", user.getRole());
            response.put("username", user.getUsername());
        } else {
            response.put("success", false);
            response.put("message", "Invalid username or password!");
        }
        return response;
    }

    /**
     * API: Logout user
     */
    @PostMapping("/api/logout")
    @ResponseBody
    public Map<String, Object> logout(HttpSession session) {
        session.invalidate();  // Destroy the session
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "Logged out successfully!");
        return response;
    }

    /**
     * API: Get all users (Admin only in real app)
     */
    @GetMapping("/api/users")
    @ResponseBody
    public List<User> getAllUsers() {
        return userService.getAllUsers();
    }

    /**
     * API: Get user by ID
     */
    @GetMapping("/api/users/{id}")
    @ResponseBody
    public User getUserById(@PathVariable Long id) {
        return userService.findById(id);
    }

    /**
     * API: Update user
     */
    @PutMapping("/api/users/{id}")
    @ResponseBody
    public Map<String, Object> updateUser(@PathVariable Long id,
                                          @RequestParam(required = false) String email,
                                          @RequestParam(required = false) String fullName,
                                          @RequestParam(required = false) String password) {
        Map<String, Object> response = new HashMap<>();
        boolean updated = userService.updateUser(id, email, fullName, password);

        response.put("success", updated);
        response.put("message", updated ? "User updated successfully!" : "User not found!");
        return response;
    }

    /**
     * API: Delete user
     */
    @DeleteMapping("/api/users/{id}")
    @ResponseBody
    public Map<String, Object> deleteUser(@PathVariable Long id) {
        Map<String, Object> response = new HashMap<>();
        boolean deleted = userService.deleteUser(id);

        response.put("success", deleted);
        response.put("message", deleted ? "User deleted successfully!" : "User not found!");
        return response;
    }
}
