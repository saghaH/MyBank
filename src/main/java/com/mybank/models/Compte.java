package com.mybank.models;



public enum Compte {
    EPARGNE("Epargne"),
    COURANT("Courant"),
    SICAV("Sicav");

    private final String value;

    private Compte(String value) {
        this.value = value;
    }

    public String getValue() {
        return value;
    }
}

