package com.mybank.controllers;

import com.mybank.models.Compte;
import com.mybank.models.DemandeImportation;
import com.mybank.security.services.CompteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/comptes")
public class CompteController {
    @Autowired
    private CompteService compteService;

    @GetMapping("/listecomptes")
    public ResponseEntity<List<Compte>> getComptesForUser(@RequestParam Long userId) {
        try {
            List<Compte> Comptes = compteService.getAllComptes();
            List<Compte> filteredComptes = Comptes.stream()
                    .filter(compte -> compte.getUser().getId().equals(userId))
                    .collect(Collectors.toList());
            return ResponseEntity.ok(filteredComptes);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }
}
