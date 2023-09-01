package com.mybank.repository;

import com.mybank.models.Compte;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CompteRepository extends JpaRepository<Compte, Long> {
    List<Compte> findByUserId(Long userId);
}
