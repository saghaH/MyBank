package com.mybank.controllers;

import com.mybank.models.DemandeOuverture;
import com.mybank.security.services.DemandeOuvertureService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

@RestController

public class DemandeOuvertureController {

    private final DemandeOuvertureService demandeOuvertureService;

    @Autowired
    public DemandeOuvertureController(DemandeOuvertureService demandeOuvertureService) {
        this.demandeOuvertureService = demandeOuvertureService;
    }

    @RequestMapping(value = {"/demandeouverture"}, method = RequestMethod.POST)
    public ResponseEntity<String> createDemandeOuverture(@RequestBody DemandeOuverture demandeOuverture, BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(bindingResult.getAllErrors().toString());
        }
        demandeOuvertureService.saveDemande(demandeOuverture);
        return ResponseEntity.ok("Demande ajoutée avec succès!");
    }
}