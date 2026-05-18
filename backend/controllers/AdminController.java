package com.toystore.onlinetoystore.controller;

import com.toystore.onlinetoystore.model.User;
import com.toystore.onlinetoystore.model.Toy;
import com.toystore.onlinetoystore.model.Order;
import com.toystore.onlinetoystore.service.UserService;
import com.toystore.onlinetoystore.service.ToyService;
import com.toystore.onlinetoystore.service.OrderService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/admin")
public class AdminController {
    private final UserService userService;
    private final ToyService toyService;
    private final OrderService orderService;

    public AdminController(UserService userService, ToyService toyService, OrderService orderService) {
        this.userService = userService;
        this.toyService = toyService;
        this.orderService = orderService;
    }

    // ============================================
    // Check if user is admin (Reusable method)
    // ============================================
    private boolean isAdmin(HttpSession session) {
        User user = (User) session.getAttribute("loggedInUser");
        return user != null && "ADMIN".equals(user.getRole());
    }
    @GetMapping("/login")
    public String showAdminLogin() {
        return "admin-login";
    }

    // Admin Logout - clears session and redirects to homepage
    @GetMapping("/logout")
    public String adminLogout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }

    // UI - Admin Dashboard
    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/login";

        model.addAttribute("totalUsers", userService.getAllUsers().size());
        model.addAttribute("totalToys", toyService.getAllToys().size());
        model.addAttribute("totalOrders", orderService.getAllOrders().size());
        model.addAttribute("recentOrders", orderService.getAllOrders());

        return "admin-dashboard";
    }

    // UI - Manage Users
    @GetMapping("/users")
    public String manageUsers(HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/login";

        model.addAttribute("users", userService.getAllUsers());
        return "admin-users";
    }

    // UI - Manage Toys
    @GetMapping("/toys")
    public String manageToys(HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/login";

        model.addAttribute("toys", toyService.getAllToys());
        return "admin-toys";
    }

    // UI - Manage Orders
    @GetMapping("/orders")
    public String manageOrders(HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/login";

        model.addAttribute("orders", orderService.getAllOrders());
        return "admin-orders";
    }

    @GetMapping("/profile")
    public String adminProfile(HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/login";

        model.addAttribute("admin", session.getAttribute("loggedInUser"));
        return "admin-profile";
    }

    @PostMapping("/api/login")
    @ResponseBody
    public Map<String, Object> adminLogin(@RequestParam String username,
                                          @RequestParam String password,
                                          HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        // Check if user exists and is admin
        User user = userService.findByUsername(username);

        if (user != null && "ADMIN".equals(user.getRole()) &&
                user.getPassword().equals(password) && user.isActive()) {

            session.setAttribute("loggedInUser", user);
            response.put("success", true);
            response.put("message", "Admin login successful!");
            response.put("username", user.getUsername());
            return response;
        }

        response.put("success", false);
        response.put("message", "Invalid admin credentials!");
        return response;
    }


    // API - Delete any user (Admin only)
    @DeleteMapping("/api/users/{id}")
    @ResponseBody
    public Map<String, Object> adminDeleteUser(HttpSession session, @PathVariable Long id) {
        Map<String, Object> response = new HashMap<>();

        if (!isAdmin(session)) {
            response.put("success", false);
            response.put("message", "Unauthorized!");
            return response;
        }

        boolean deleted = userService.deleteUser(id);
        response.put("success", deleted);
        response.put("message", deleted ? "User deleted!" : "User not found!");
        return response;
    }

    // API - Update order status (Admin only)
    @PutMapping("/api/orders/{orderId}/status")
    @ResponseBody
    public Map<String, Object> updateOrderStatus(HttpSession session,
                                                 @PathVariable Long orderId,
                                                 @RequestParam String status) {
        Map<String, Object> response = new HashMap<>();

        User user = (User) session.getAttribute("loggedInUser");
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.put("success", false);
            response.put("message", "Unauthorized! Please login as admin.");
            System.out.println("Unauthorized access");
            return response;
        }

        boolean updated = orderService.updateOrderStatus(orderId, status);
        response.put("success", updated);
        response.put("message", updated ? "Status updated!" : "Order not found!");
        return response;
    }

    // API - Get all users (Admin only)
    @GetMapping("/api/users/all")
    @ResponseBody
    public List<User> getAllUsers(HttpSession session) {
        if (!isAdmin(session)) return List.of();
        return userService.getAllUsers();
    }

    // API - Get all orders (Admin only)
    @GetMapping("/api/orders/all")
    @ResponseBody
    public List<Order> getAllOrders(HttpSession session) {
        if (!isAdmin(session)) return List.of();
        return orderService.getAllOrders();
    }
}
