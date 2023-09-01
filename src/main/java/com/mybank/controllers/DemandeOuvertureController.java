package com.mybank.controllers;

import com.mybank.models.DemandeImportation;
import com.mybank.models.DemandeOuverture;
import com.mybank.models.User;

import com.mybank.repository.DemandeOuvertureRepository;
import com.mybank.repository.UserRepository;
import com.mybank.security.services.DemandeImportationService;
import com.mybank.security.services.DemandeOuvertureService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api")
public class DemandeOuvertureController {

    @Autowired
    private DemandeOuvertureService demandeOuvertureService;
    @Autowired
    private DemandeImportationService demandeImportationService;

    @Autowired
    private DemandeOuvertureRepository demandeOuvertureRepository;

    @Autowired
    UserRepository userRepository;

    private byte[] compressImage(byte[] imageBytes) throws IOException {

        ByteArrayInputStream inputStream = new ByteArrayInputStream(imageBytes);
        BufferedImage bufferedImage = ImageIO.read(inputStream);


        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();


        ImageIO.write(bufferedImage, "jpg", outputStream);


        byte[] compressedImageBytes = outputStream.toByteArray();


        inputStream.close();
        outputStream.close();

        return compressedImageBytes;
    }





    @PostMapping("/demandeouverture")
    public ResponseEntity<String> createDemandeOuverture(
            @RequestParam("cinVerso") MultipartFile cinVersoFile,
            @RequestParam("cinR") MultipartFile cinRectoFile,
            @RequestParam("justifAdr") MultipartFile justifAdr,
            @RequestParam("justifR") MultipartFile justifR,
            @RequestParam("selfie") MultipartFile selfieFile,
            @RequestParam("userId") String userId,
            @RequestParam("typeCompte") String typeCompte) {

        try {
            DemandeOuverture demandeOuverture = new DemandeOuverture();
            Long userIdLong = Long.parseLong(userId);
            User user = new User();
            user.setId(userIdLong);
            demandeOuverture.setUser(user);
            demandeOuverture.setTypeCompte(typeCompte);
            demandeOuverture.setCinVerso(compressImage(cinVersoFile.getBytes()));
            demandeOuverture.setCinR(compressImage(cinRectoFile.getBytes()));
            demandeOuverture.setJustifAdr(compressImage(justifAdr.getBytes()));
            demandeOuverture.setJustifR(compressImage(justifR.getBytes()));


            demandeOuverture.setSelfie(compressImage(selfieFile.getBytes()));
            demandeOuvertureService.saveDemande(demandeOuverture);

            return ResponseEntity.ok("Demande ajoutée avec succès!");
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error uploading images.");
        }
    }



    @PostMapping("/demandeimportation")
    public ResponseEntity<String> createdemandeImportation(
            @RequestParam("cinVerso") MultipartFile cinVersoFile,
            @RequestParam("cinRecto") MultipartFile cinRectoFile,
            @RequestParam("userId") String userId) {

        try {
            DemandeImportation demandeImportation = new DemandeImportation();
            Long userIdLong = Long.parseLong(userId);
            User user = new User();
            user.setId(userIdLong);
            demandeImportation.setUser(user);
            demandeImportation.setCinVerso(cinVersoFile.getBytes());
            demandeImportation.setCinRecto(cinRectoFile.getBytes());
            demandeImportationService.saveDemande(demandeImportation);

            return ResponseEntity.ok("Demande importation ajoutée avec succès!");
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error uploading images.");
        }
    }


    @GetMapping("/demandeouverture")
    public ResponseEntity<List<DemandeOuverture>> getAllDemandeOuvertureForUser(@RequestParam Long userId) {
        try {
            List<DemandeOuverture> demandesOuverture = demandeOuvertureService.getAllDemandeOuverture();
            List<DemandeOuverture> filteredDemandes = demandesOuverture.stream()
                    .filter(demande -> demande.getUser().getId().equals(userId))
                    .collect(Collectors.toList());
            return ResponseEntity.ok(filteredDemandes);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }


    @GetMapping("/demandeimportation")
    public ResponseEntity<List<DemandeImportation>> getAllDemandeImportationForUser(@RequestParam Long userId) {
        try {
            List<DemandeImportation> demandesImportation = demandeImportationService.getAllDemandeImportation();
            List<DemandeImportation> filteredDemandes = demandesImportation.stream()
                    .filter(demande -> demande.getUser().getId().equals(userId))
                    .collect(Collectors.toList());
            return ResponseEntity.ok(filteredDemandes);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }


}
