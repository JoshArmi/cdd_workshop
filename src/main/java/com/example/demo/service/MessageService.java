package com.example.demo.service;

import com.example.demo.model.Message;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
public class MessageService {
    private final List<Message> messages = new ArrayList<>();
    private final DateTimeFormatter formatter = DateTimeFormatter.ISO_OFFSET_DATE_TIME;

    public Message createMessage(UUID id, String content) {
        Message message = new Message(
            id.toString(),
            content,
            LocalDateTime.now().atOffset(ZoneOffset.UTC).format(formatter)
        );
        messages.add(message);
        return message;
    }

    public List<Message> getAllMessages() {
        return new ArrayList<>(messages);
    }

    public Optional<Message> getMessageById(UUID id) {
        return messages.stream()
                .filter(message -> message.getId().equals(id.toString()))  
                .findFirst();
    }
} 
