package com.mybank.models;



import com.mybank.models.Compte;
import com.mybank.models.User;
import jakarta.persistence.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "demande_ouverture")
public class DemandeOuverture {

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
    private byte[] cinR;
    @Lob
    private byte[] justifR;

    @Lob
    private byte[] justifAdr;

    @Lob
    private byte[] selfie;
    @Enumerated(EnumType.STRING)
    @Column(name = "type_compte")
    private Compte typeCompte;


    public DemandeOuverture() {
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

    public byte[] getCinR() {
        return cinR;
    }

    public void setCinR(byte[] cinR) {
        this.cinR = cinR;
    }

    public byte[] getJustifR() {
        return justifR;
    }

    public void setJustifR(byte[] justifR) {
        this.justifR = justifR;
    }

    public byte[] getJustifAdr() {
        return justifAdr;
    }

    public void setJustifAdr(byte[] justifAdr) {
        this.justifAdr = justifAdr;
    }

    public byte[] getSelfie() {
        return selfie;
    }

    public void setSelfie(byte[] selfie) {
        this.selfie = selfie;
    }

    public Compte getTypeCompte() {
        return typeCompte;
    }

    public void setTypeCompte(Compte typeCompte) {
        this.typeCompte = typeCompte;
    }
}
