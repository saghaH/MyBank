package com.mybank.controllers;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

import com.mybank.models.*;
import com.mybank.payload.request.BiometricLoginRequest;
import com.mybank.repository.RoleRepository;
import com.mybank.repository.UserRepository;
import com.mybank.security.jwt.JwtUtils;
import com.mybank.security.services.EmailService;
import com.mybank.security.services.UserDetailsImpl;
import jakarta.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.validation.BindingResult;
import org.springframework.validation.ObjectError;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import com.mybank.payload.request.LoginRequest;
import com.mybank.payload.request.SignupRequest;
import com.mybank.payload.request.ForgotPasswordRequest;
import com.mybank.payload.response.JwtResponse;
import com.mybank.payload.response.MessageResponse;
import com.mybank.repository.PasswordResetTokenRepository;



@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/auth")
public class AuthController {
  @Autowired
  AuthenticationManager authenticationManager;

  @Autowired
  UserRepository userRepository;

  @Autowired
  RoleRepository roleRepository;

  @Autowired
  PasswordEncoder encoder;

  @Autowired
  JwtUtils jwtUtils;
  @Autowired
  private PasswordResetTokenRepository passwordResetTokenRepository;
  @Autowired
  EmailService emailService;
  @PostMapping("/signin")
  public ResponseEntity<?> authenticateUser(@Valid @RequestBody LoginRequest loginRequest) {

    Authentication authentication = authenticationManager
        .authenticate(new UsernamePasswordAuthenticationToken(loginRequest.getUsername(), loginRequest.getPassword()));
    SecurityContextHolder.getContext().setAuthentication(authentication);
    String jwt = jwtUtils.generateJwtToken(authentication);
    UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();
   /* Authentication authentication = new UsernamePasswordAuthenticationToken(loginRequest.getUsername(), null);
    SecurityContextHolder.getContext().setAuthentication(authentication);

    String jwt = jwtUtils.generateJwtToken(authentication);
    UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();*/
    List<String> roles = userDetails.getAuthorities().stream().map(item -> item.getAuthority())
        .collect(Collectors.toList());
    User user = userRepository.findById(userDetails.getId()).orElse(null);
    UserDTO userDTO = new UserDTO();
    userDTO.setId(userDetails.getId());
    userDTO.setUsername(userDetails.getUsername());
    userDTO.setEmail(userDetails.getEmail());
    userDTO.setRoles(roles);
    userDTO.setFirstName(user.getFirstName());
    userDTO.setLastName(user.getLastName());
    userDTO.setMobileNumber(user.getMobileNumber());
    userDTO.setDateOfBirth(user.getDateOfBirth());
    userDTO.setNationality(user.getNationality());
    userDTO.setAddress(user.getAddress());
    userDTO.setCountryOfResidence(user.getCountryOfResidence());
    userDTO.setJobField(user.getJobField());
    userDTO.setJob(user.getJob());
    userDTO.setCinNumber(user.getCinNumber());

    return ResponseEntity
            .ok(new JwtResponse(jwt, userDTO));
  }













  @PostMapping("/signup")
  public ResponseEntity<?> registerUser(@Valid @RequestBody SignupRequest signUpRequest) {
    if (userRepository.existsByUsername(signUpRequest.getUsername())) {
      return ResponseEntity.badRequest().body(new MessageResponse("Error: Username is already taken!"));
    }

    if (userRepository.existsByEmail(signUpRequest.getEmail())) {
      return ResponseEntity.badRequest().body(new MessageResponse("Error: Email is already in use!"));
    }

    // Create new user's account
    User user = new User(signUpRequest.getUsername(),
            signUpRequest.getEmail(),
            encoder.encode(signUpRequest.getPassword()));

    // Set additional fields
    user.setFirstName(signUpRequest.getFirstName());
    user.setLastName(signUpRequest.getLastName());
    user.setMobileNumber(signUpRequest.getMobileNumber());
    user.setDateOfBirth(signUpRequest.getDateOfBirth());
    //user.setNationality(signUpRequest.getNationality());
    user.setAddress(signUpRequest.getAddress());
    //user.setCountryOfResidence(signUpRequest.getCountryOfResidence());
   // user.setJobField(signUpRequest.getJobField());
    user.setJob(signUpRequest.getJob());
    user.setCinNumber(signUpRequest.getCinNumber());

    // Assign the "ROLE_USER" role to the user
    Role userRole = roleRepository.findByName(ERole.ROLE_USER)
            .orElseThrow(() -> new RuntimeException("Error: Role is not found."));
    Set<Role> roles = new HashSet<>();
    roles.add(userRole);

    user.setRoles(roles);
    //user.setBiometric(false);
    userRepository.save(user);

    return ResponseEntity.ok(new MessageResponse("User registered successfully!"));
  }
  @PostMapping("/forgotpassword")
  public ResponseEntity<String> forgotPasswordSubmit(
          @Validated @RequestBody ForgotPasswordRequest forgotPasswordRequest,
          BindingResult bindingResult) {
    // Check for validation errors
    if (bindingResult.hasErrors()) {
      StringBuilder errorMessages = new StringBuilder();
      for (ObjectError error : bindingResult.getAllErrors()) {
        errorMessages.append(error.getDefaultMessage()).append("\n");
      }
      return ResponseEntity.badRequest().body(errorMessages.toString());
    }

    String email = forgotPasswordRequest.getEmail();

    // Use the findByEmail method to get the user
    Optional<User> optionalUser = userRepository.findByEmail(email);

    if (!optionalUser.isPresent()) {
      return ResponseEntity.badRequest().body("User with this email address doesn't exist.");
    }

    User user = optionalUser.get();

    // Generate a reset token and save it in the database
    PasswordResetToken token = new PasswordResetToken();
    token.setToken(UUID.randomUUID().toString());
    token.setUser(user);
    token.setExpiryDate(30);
    passwordResetTokenRepository.save(token);

    // Create a reset link
    String resetUrl = "http://192.168.1.20:8080/resetpassword?token=" + token.getToken();

    // Send an email with the reset link
    Mail mail = new Mail();
    mail.setFrom("mybankspringflutter@gmail.com");
    mail.setTo(user.getEmail());
    mail.setSubject("Password Reset Link");
    mail.setContent("To reset your password, click the following link: " + resetUrl);

    emailService.sendEmail(mail);

    return ResponseEntity.ok("Password reset request submitted successfully.");
  }
  @GetMapping("/biometric-true")
  public ResponseEntity<List<User>> getUsersWithBiometricEnabled() {
    List<User> usersWithBiometricEnabled = userRepository.findByBiometricIsTrue();

  return ResponseEntity.ok(usersWithBiometricEnabled);
  }

  @PostMapping("/biometric-login")
  public ResponseEntity<?> biometricLogin(@RequestBody BiometricLoginRequest request) {
    Authentication authentication = authenticateUserByUsername(request);

    SecurityContextHolder.getContext().setAuthentication(authentication);

    // Generate a JWT token
    String jwtToken = jwtUtils.generateJwtToken(authentication);

    // Retrieve user details based on the username
    UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();
    List<String> roles = userDetails.getAuthorities().stream().map(item -> item.getAuthority())
            .collect(Collectors.toList());

    User user = userRepository.findById(userDetails.getId()).orElse(null);

    // Create a UserDTO object with the user information
    UserDTO userDTO = new UserDTO();
    userDTO.setId(userDetails.getId());
    userDTO.setUsername(userDetails.getUsername());
    userDTO.setEmail(userDetails.getEmail());
    userDTO.setRoles(roles);
    userDTO.setFirstName(user.getFirstName());
    userDTO.setLastName(user.getLastName());
    userDTO.setMobileNumber(user.getMobileNumber());
    userDTO.setDateOfBirth(user.getDateOfBirth());
    userDTO.setNationality(user.getNationality());
    userDTO.setAddress(user.getAddress());
    userDTO.setCountryOfResidence(user.getCountryOfResidence());
    userDTO.setJobField(user.getJobField());
    userDTO.setJob(user.getJob());
    userDTO.setCinNumber(user.getCinNumber());

    return ResponseEntity
            .ok(new JwtResponse(jwtToken, userDTO));

  }

  private Authentication authenticateUserByUsername(BiometricLoginRequest request) {
    String username = request.getUsername();

    // Load user details based on the username
    UserDetails userDetails = loadUserByUsername(username);

    // Create an authentication object
    return new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());
  }

  private UserDetails loadUserByUsername(String username) {
    // Implement the logic to load user details by username from your database
    // This might involve querying the UserRepository or another service

    // For example:
    User user = userRepository.findByUsername(username);
    if (user == null) {
      throw new UsernameNotFoundException("User not found with username: " + username);
    }

    return new UserDetailsImpl(user);
  }



}
