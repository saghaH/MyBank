package com.mybank.controllers;

import com.mybank.models.Message;
import com.mybank.models.User;
import com.mybank.repository.MessageRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("/api/messages")
public class MessageController {

    @Autowired
    private MessageRepository messageRepository;

    @PostMapping("/add")
    public ResponseEntity<String> addMessage(
            @RequestParam("userId") String userId,
            @RequestParam("subject") String subject,
            @RequestParam("body") String body) {
        Message message = new Message();
        Long userIdLong = Long.parseLong(userId);
        User user = new User();
        user.setId(userIdLong);
        message.setUser(user);
        message.setSubject(subject);
        message.setBody(body);
        messageRepository.save(message);
        return ResponseEntity.ok("Message ajouté avec succès!");
    }
}
