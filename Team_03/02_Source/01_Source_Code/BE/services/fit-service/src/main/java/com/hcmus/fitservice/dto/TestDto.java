package com.hcmus.fitservice.dto;

import com.hcmus.fitservice.db.model.Test;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.io.Serializable;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class TestDto {
    Integer id;
    @Size(max = 255)
    String content;

    public TestDto(Test test) {
        this.id = test.getId();
        this.content = test.getContent();
    }
}