package com.mybank.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.mybank.models.User;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
  User findByUsername(String username);

  Boolean existsByUsername(String username);

  Boolean existsByEmail(String email);

  Optional<User> findByEmail(String email);
  List<User> findByBiometricIsTrue();
}
