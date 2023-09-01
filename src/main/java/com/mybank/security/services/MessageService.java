package com.mybank.security.services;

import com.mybank.models.Message;

import java.util.List;

public interface MessageService {
    Message saveMessage(Message message);
    List<Message> getAllMessages();

}

