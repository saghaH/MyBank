package com.mybank.security.services;


import com.mybank.models.DemandeOuverture;

import java.util.List;

public interface DemandeOuvertureService {
    DemandeOuverture saveDemande(DemandeOuverture demandeOuverture);
    List<DemandeOuverture> getAllDemandeOuverture();



}
