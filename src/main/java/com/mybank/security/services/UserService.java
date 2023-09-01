package com.mybank.security.services;

import com.mybank.models.User;
import org.springframework.stereotype.Service;

@Service
public interface UserService {
    User updateUserInfo(Long userId, User updatedUser);
}

