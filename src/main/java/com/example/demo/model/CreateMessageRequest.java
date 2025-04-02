package com.example.demo.model;

import jakarta.validation.constraints.NotNull;
import java.util.UUID;

public class CreateMessageRequest {
    @NotNull(message = "id is required")
    private UUID id;
    
    @NotNull(message = "content is required")
    private String content;

    public CreateMessageRequest() {
    }

    public CreateMessageRequest(UUID id, String content) {
        this.id = id;
        this.content = content;
    }

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }
} 
