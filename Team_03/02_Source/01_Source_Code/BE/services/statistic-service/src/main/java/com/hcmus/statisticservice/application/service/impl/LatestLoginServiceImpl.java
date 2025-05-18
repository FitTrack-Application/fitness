package com.hcmus.statisticservice.application.service.impl;

import com.hcmus.statisticservice.application.dto.response.ApiResponse;
import com.hcmus.statisticservice.domain.model.LatestLogin;
import com.hcmus.statisticservice.domain.repository.LatestLoginRepository;

import lombok.RequiredArgsConstructor;
import com.hcmus.statisticservice.application.service.LatestLoginService;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class LatestLoginServiceImpl implements LatestLoginService {
    private final LatestLoginRepository latestLoginRepository;

    @Override
    public ApiResponse<?> updateLatestLogin(UUID userId) {
        LatestLogin latestLogin = latestLoginRepository.findByUserId(userId);
        if (latestLogin == null) {
            latestLogin = new LatestLogin();
            latestLogin.setUserId(userId);
            latestLogin.setDate(Date.from(LocalDate.now().atStartOfDay(ZoneId.systemDefault()).toInstant()));
            latestLoginRepository.save(latestLogin);
            
            return ApiResponse.builder()
                    .status(HttpStatus.OK.value())
                    .generalMessage("Successfully tracked latest login!")
                    .build();
        }

        latestLogin.setDate(Date.from(LocalDate.now().atStartOfDay(ZoneId.systemDefault()).toInstant()));

        latestLoginRepository.save(latestLogin);
        
        return ApiResponse.builder()
                .status(HttpStatus.OK.value())
                .generalMessage("Successfully updated latest login!")
                .build();
    }
    
}
