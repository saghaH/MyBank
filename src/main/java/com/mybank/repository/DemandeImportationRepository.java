package com.mybank.repository;

import com.mybank.models.DemandeImportation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface DemandeImportationRepository extends JpaRepository<DemandeImportation, Long> {
    DemandeImportation findByUserId(Long userId);
}
