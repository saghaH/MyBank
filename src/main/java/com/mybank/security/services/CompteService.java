package com.mybank.security.services;

import com.mybank.models.Compte;

import java.util.List;

public interface CompteService {
    List<Compte> getComptesByUserId(Long userId);

    List<Compte> getAllComptes();
}
