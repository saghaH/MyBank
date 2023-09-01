package com.mybank.repository;

import com.mybank.models.Biometric;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface BiometricRepository extends JpaRepository<Biometric, Long> {
    Biometric findByUsername(String username);
    List<Biometric> findAll();
}

