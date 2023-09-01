package com.mybank.security.services;

import com.mybank.models.DemandeImportation;


import java.util.List;

public interface DemandeImportationService {
    DemandeImportation saveDemande(DemandeImportation demandeImportation);


    List<DemandeImportation> getAllDemandeImportation();
}