package com.mybank.security.services;

import com.mybank.models.DemandeOuverture;
import com.mybank.repository.DemandeOuvertureRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
public class DemandeOuvertureServiceImpl implements DemandeOuvertureService {

    @Autowired
    private DemandeOuvertureRepository demandeOuvertureRepository;

    @Override
    public DemandeOuverture saveDemande(DemandeOuverture demandeOuverture) {
        demandeOuverture.setCreationDate(LocalDateTime.now());
        demandeOuverture.setStatut("En cours de traitement");
        return demandeOuvertureRepository.save(demandeOuverture);
    }


}
