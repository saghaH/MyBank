package com.mybank.models;

import java.time.LocalDate;
import java.util.HashSet;
import java.util.Set;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;

@Entity
@Table( name = "users", 
        uniqueConstraints = { 
          @UniqueConstraint(columnNames = "username"),
          @UniqueConstraint(columnNames = "email") 
        })
public class User {
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  @NotBlank
  @Size(max = 20)
  private String username;

  @NotBlank
  @Size(max = 50)
  @Email
  private String email;

  @NotBlank
  @Size(max = 120)
  private String password;

@NotBlank
private String cinNumber;

  @NotBlank
  @Size(max = 50)
  private String firstName;

  @NotBlank
  @Size(max = 50)
  private String lastName;

  @NotBlank
  @Size(max = 15)
  private String mobileNumber;

  //@NotNull
  @Past(message = "Date of birth must be in the past")
  private LocalDate dateOfBirth;

  //@NotBlank
  @Size(max = 50)
  private String nationality;

  @NotBlank
  @Size(max = 100)
  private String address;

  //@NotBlank
  @Size(max = 50)
  private String countryOfResidence;

  //@NotBlank
  @Size(max = 50)
  private String jobField;

  @NotBlank
  @Size(max = 50)
  private String job;

  @NotNull
  private boolean biometric=false;




  @ManyToMany(fetch = FetchType.LAZY)
  @JoinTable(name = "user_roles", joinColumns = @JoinColumn(name = "user_id"), inverseJoinColumns = @JoinColumn(name = "role_id"))
  private Set<Role> roles = new HashSet<>();

  public User() {
  }

  public User(String username, String email, String password) {
    this.username = username;
    this.email = email;
    this.password = password;
  }

  public void setBiometric(boolean biometric) {
    this.biometric = biometric;
  }

  public User(Long userId) {
  }

  public String getCinNumber() {
    return cinNumber;
  }

  public void setCinNumber(String cinNumber) {
    this.cinNumber = cinNumber;
  }

  public Long getId() {
    return id;
  }

  public void setId(Long id) {
    this.id = id;
  }

  public String getUsername() {
    return username;
  }

  public void setUsername(String username) {
    this.username = username;
  }

  public String getEmail() {
    return email;
  }

  public void setEmail(String email) {
    this.email = email;
  }

  public String getPassword() {
    return password;
  }

  public void setPassword(String password) {
    this.password = password;
  }

  public Set<Role> getRoles() {
    return roles;
  }

  public void setRoles(Set<Role> roles) {
    this.roles = roles;
  }



  public String getFirstName() {
    return firstName;
  }

  public void setFirstName(String firstName) {
    this.firstName = firstName;
  }

  public String getLastName() {
    return lastName;
  }

  public void setLastName(String lastName) {
    this.lastName = lastName;
  }

  public String getMobileNumber() {
    return mobileNumber;
  }

  public void setMobileNumber(String mobileNumber) {
    this.mobileNumber = mobileNumber;
  }

  public LocalDate getDateOfBirth() {
    return dateOfBirth;
  }

  public void setDateOfBirth(LocalDate dateOfBirth) {
    this.dateOfBirth = dateOfBirth;
  }

  public String getNationality() {
    return nationality;
  }

  public void setNationality(String nationality) {
    this.nationality = nationality;
  }

  public String getAddress() {
    return address;
  }

  public void setAddress(String address) {
    this.address = address;
  }

  public String getCountryOfResidence() {
    return countryOfResidence;
  }

  public void setCountryOfResidence(String countryOfResidence) {
    this.countryOfResidence = countryOfResidence;
  }

  public String getJobField() {
    return jobField;
  }

  public void setJobField(String jobField) {
    this.jobField = jobField;
  }

  public String getJob() {
    return job;
  }

  public void setJob(String job) {
    this.job = job;
  }
}
