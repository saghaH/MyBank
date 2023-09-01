package com.mybank.security.services;

import com.mybank.models.Compte;

import com.mybank.repository.CompteRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CompteServiceImpl implements CompteService {
    @Autowired
    private CompteRepository compteRepository;

    @Override
    public List<Compte> getComptesByUserId(Long userId) {
        return compteRepository.findByUserId(userId);
    }

    @Override
    public List<Compte> getAllComptes() {

            return compteRepository.findAll();
        }
    }

