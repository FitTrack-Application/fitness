package com.hcmus.fitservice.service;

import com.hcmus.fitservice.dto.TestDto;
import com.hcmus.fitservice.db.model.Test;
import com.hcmus.fitservice.repository.TestRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@AllArgsConstructor
public class TestServiceImpl implements TestService {

    private final TestRepository testRepository;

    @Override
    public TestDto testServer() {
        Test test = testRepository.findById(1).orElse(null);
        if (test == null) {
            return null;
        }
        return new TestDto(test);
    }
}
