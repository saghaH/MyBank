package com.mybank.security.services;

import com.mybank.models.Mail;

public interface EmailService {
    void sendEmail(Mail mail);
}
