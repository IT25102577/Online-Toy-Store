package com.toystore.onlinetoystore.service;

import com.toystore.onlinetoystore.model.User;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import java.util.*;
import java.util.stream.Collectors;
@Service
public class UserService {

    @Value("${file.users}")
    private String usersFile;

    private final FileService fileService;

    public UserService(FileService fileService) {
        this.fileService = fileService;

    }
    // CREATE OPERATION
    /**
     * Register a new customer user
     */
    public User register(String username, String password, String email, String fullName) {
        if (findByUsername(username) != null) {
            return null;
        }

       
        long newId = fileService.getNextId(usersFile);

        
        User user = new User(newId, username, password, email, fullName, "CUSTOMER", true);

        
        fileService.appendLine(usersFile, user.toFileString());

        return user;
    }
    // READ OPERATIONS
    /**
     * Get all users from the file
     */
    public List<User> getAllUsers() {
        List<String> lines = fileService.readAllLines(usersFile);
        return lines.stream()
                .map(User::fromFileString)
                .collect(Collectors.toList());
    }

    /**
     * Find a user by their username
     */
    public User findByUsername(String username) {
        return getAllUsers().stream()
                .filter(u -> u.getUsername().equals(username) && u.isActive())
                .findFirst()
                .orElse(null);
    }

    /**
     * Find a user by their ID
     */
    public User findById(Long id) {
        return getAllUsers().stream()
                .filter(u -> u.getId().equals(id))
                .findFirst()
                .orElse(null);
    }

    /**
     * LOGIN - verify username and password
     */
    public User login(String username, String password) {
        User user = findByUsername(username);
        if (user != null && user.getPassword().equals(password) && user.isActive()) {
            return user;
        }
        return null;
    }

    // UPDATE OPERATION 
    /**
     * Update user profile information
     */
    public boolean updateUser(Long id, String email, String fullName, String password) {
        List<User> users = getAllUsers();
        boolean found = false;

        for (int i = 0; i < users.size(); i++) {
            if (users.get(i).getId().equals(id)) {
                User u = users.get(i);
                if (email != null && !email.isEmpty()) u.setEmail(email);
                if (fullName != null && !fullName.isEmpty()) u.setFullName(fullName);
                if (password != null && !password.isEmpty()) u.setPassword(password);
                users.set(i, u);
                found = true;
                break;
            }
        }

        if (found) {
            saveAllUsers(users);
        }
        return found;
    }

    // DELETE OPERATION 
    /**
     * Hard delete - completely remove user from file
     */
    public boolean deleteUser(Long id) {
        List<User> users = getAllUsers();
        boolean removed = users.removeIf(u -> u.getId().equals(id));

        if (removed) {
            saveAllUsers(users);
        }
        return removed;
    }

    /**
     * Soft delete - just deactivate the account (keep in file)
     */
    public boolean deactivateUser(Long id) {
        List<User> users = getAllUsers();
        boolean found = false;

        for (User user : users) {
            if (user.getId().equals(id)) {
                user.setActive(false);
                found = true;
                break;
            }
        }

        if (found) {
            saveAllUsers(users);
        }
        return found;
    }


    //saves all users to file
    private void saveAllUsers(List<User> users) {
        List<String> lines = users.stream()
                .map(User::toFileString)
                .collect(Collectors.toList());
        fileService.writeAllLines(usersFile, lines);
    }
}