package com.mybank.security.services;

import com.mybank.models.DemandeImportation;
import com.mybank.repository.DemandeImportationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class DemandeImportationServiceImpl implements DemandeImportationService {

    @Autowired
    private DemandeImportationRepository demandeImportationRepository;

    public DemandeImportation saveDemande(DemandeImportation demandeImportation) {
        demandeImportation.setCreationDate(LocalDateTime.now());
        demandeImportation.setStatut("En cours de traitement");
        return demandeImportationRepository.save(demandeImportation);
    }

    @Override
    public List<DemandeImportation> getAllDemandeImportation() {
        return demandeImportationRepository.findAll();
    }


}
