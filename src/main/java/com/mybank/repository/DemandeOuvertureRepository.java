package com.mybank.repository;

import com.mybank.models.DemandeOuverture;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface DemandeOuvertureRepository extends JpaRepository<DemandeOuverture, Long> {
    List<DemandeOuverture> findByUserId(Long userId);

}
