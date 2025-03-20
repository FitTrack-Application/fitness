package com.hcmus.fitservice.dto;

import com.hcmus.fitservice.db.model.Test;
import jakarta.validation.constraints.Size;

import java.io.Serializable;

public class TestDto implements Serializable {
    Integer id;
    @Size(max = 255)
    String content;

    public TestDto(Test test) {
        this.id = test.getId();
        this.content = test.getContent();
    }
}