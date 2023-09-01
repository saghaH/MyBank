package com.mybank.security.services;

import com.mybank.models.User;
import com.mybank.repository.UserRepository;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;

public class UserServiceImpl implements UserService{

    @Autowired
    private UserRepository userRepository;

    @Override
    public User updateUserInfo(Long userId, User updatedUser) {
        User existingUser = userRepository.findById(userId)
                .orElseThrow(() -> new EntityNotFoundException("User not found"));


        existingUser.setFirstName(updatedUser.getFirstName());
        existingUser.setLastName(updatedUser.getLastName());
        existingUser.setDateOfBirth(updatedUser.getDateOfBirth());
        existingUser.setAddress(updatedUser.getAddress());
        existingUser.setJob(updatedUser.getJob());

        return userRepository.save(existingUser);
    }


}
