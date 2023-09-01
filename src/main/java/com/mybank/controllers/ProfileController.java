package com.mybank.controllers;

import com.mybank.models.User;
import com.mybank.payload.request.ModifyPasswordRequest;
import com.mybank.payload.request.PasswordChangeRequest;
import com.mybank.payload.request.UpdateRequest;
import com.mybank.repository.RoleRepository;
import com.mybank.security.services.UserDetailsImpl;
import com.mybank.security.services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;
import com.mybank.repository.UserRepository;

import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.Optional;

@RestController
public class ProfileController {

    @Autowired
    UserRepository userRepository;
    @Autowired
    private PasswordEncoder passwordEncoder;

    private UserService userService;




    @PostMapping("/modifypwd")
    public ResponseEntity<?> modifyPassword(@RequestBody ModifyPasswordRequest passwordRequest) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();
        User user = userRepository.findById(userDetails.getId()).orElse(null);

        if (user == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User not found.");
        }

        if (!passwordEncoder.matches(passwordRequest.getOldPwd(), user.getPassword())) {
            return ResponseEntity.badRequest().body("Old password is incorrect.");
        }

        if (!passwordRequest.getNewPwd().equals(passwordRequest.getConfirmPwd())) {
            return ResponseEntity.badRequest().body("New passwords do not match.");
        }

        user.setPassword(passwordEncoder.encode(passwordRequest.getNewPwd()));
        userRepository.save(user);

        return ResponseEntity.ok("Password modified successfully.");
    }

    @PutMapping("/update")
    public ResponseEntity<String> updateUserInformation(@RequestBody UpdateRequest updateUserRequest) {
        // Find the user by userId
        User user = userRepository.findByUsername(updateUserRequest.getUsername());
        if (user == null) {
            return ResponseEntity.notFound().build();
        }

        // Update user's fields if they're not null
        if (updateUserRequest.getFirstName() != null) {
            user.setFirstName(updateUserRequest.getFirstName());
        }
        if (updateUserRequest.getLastName() != null) {
            user.setLastName(updateUserRequest.getLastName());
        }
        if (updateUserRequest.getAddress() != null) {
            user.setAddress(updateUserRequest.getAddress());
        }
        if (updateUserRequest.getJob() != null) {
            user.setJob(updateUserRequest.getJob());
        }
        if (updateUserRequest.getMobileNumber() != null) {
            user.setMobileNumber(updateUserRequest.getMobileNumber());
        }


        try {
            userRepository.save(user);
            return ResponseEntity.ok("User information updated successfully");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("An error occurred while updating user information.");
        }
    }

}
