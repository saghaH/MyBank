package com.mybank.models;

import jakarta.persistence.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "demande_importation")
public class DemandeImportation {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    @Column(name = "creation_date")
    private LocalDateTime creationDate;

    @Column(name = "statut")
    private String statut;

    @Lob
    private byte[] cinVerso;

    @Lob
    private byte[] cinRecto;

    public DemandeImportation() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public LocalDateTime getCreationDate() {
        return creationDate;
    }

    public void setCreationDate(LocalDateTime creationDate) {
        this.creationDate = creationDate;
    }

    public String getStatut() {
        return statut;
    }

    public void setStatut(String statut) {
        this.statut = statut;
    }

    public byte[] getCinVerso() {
        return cinVerso;
    }

    public void setCinVerso(byte[] cinVerso) {
        this.cinVerso = cinVerso;
    }

    public byte[] getCinRecto() {
        return cinRecto;
    }

    public void setCinRecto(byte[] cinRecto) {
        this.cinRecto = cinRecto;
    }
}