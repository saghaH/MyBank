package com.mybank.controllers;

import com.mybank.models.Biometric;
import com.mybank.models.User;
import com.mybank.repository.BiometricRepository;
import com.mybank.repository.UserRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.apache.commons.codec.binary.Base64;
import org.springframework.stereotype.Service;

import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;
import javax.security.auth.kerberos.EncryptionKey;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.security.NoSuchAlgorithmException;


@RestController
@RequestMapping("/api/biometric")
public class BiometricController {


    String secretKey = "secretkey";

    @Autowired
    private BiometricRepository biometricRepository;


    @Autowired
    UserRepository userRepository;
@Autowired
PasswordEncoder passwordEncoder;

    public BiometricController() throws NoSuchAlgorithmException {
    }

    @PostMapping("/add")
    public ResponseEntity<String> addBiometric(@RequestParam String username, @RequestParam String password) {
        try {

            User user = userRepository.findByUsername(username);

            if (user == null) {
                return ResponseEntity.badRequest().body("User not found");
            }
            String storedPassword = user.getPassword();


            if (!passwordEncoder.matches(password, storedPassword)) {
                return ResponseEntity.badRequest().body("Incorrect password");
            }

         user.setBiometric(true);


            byte[] keyBytes = secretKey.getBytes();

            Cipher cipher = Cipher.getInstance("AES/ECB/PKCS5Padding");
            SecretKeySpec key = new SecretKeySpec(keyBytes, "AES");

            cipher.init(Cipher.ENCRYPT_MODE, key);

            byte[] cipherText = cipher.doFinal(password.getBytes(StandardCharsets.UTF_8));

            String encodedPassword = Base64.encodeBase64URLSafeString(cipherText);







            Biometric biometric = new Biometric();
            biometric.setUsername(username);
            biometric.setPassword(encodedPassword);


            biometricRepository.save(biometric);

            return ResponseEntity.ok("Biometric added successfully");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Failed to add biometric: " + e.getMessage());
        }
    }
}
