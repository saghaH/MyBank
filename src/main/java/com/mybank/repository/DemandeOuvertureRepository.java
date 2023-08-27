package com.mybank.repository;

import com.mybank.models.DemandeOuverture;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface DemandeOuvertureRepository extends JpaRepository<DemandeOuverture, Long> {

}
