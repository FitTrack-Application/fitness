package com.hcmus.statisticservice.application.service;

import com.hcmus.statisticservice.application.dto.request.UpdateProfileRequest;
import com.hcmus.statisticservice.application.dto.response.ApiResponse;
import com.hcmus.statisticservice.application.dto.response.FitProfileResponse;
import com.hcmus.statisticservice.application.mapper.FitProfileMapper;
import com.hcmus.statisticservice.application.service.impl.FitProfileServiceImpl;
import com.hcmus.statisticservice.domain.exception.StatisticException;
import com.hcmus.statisticservice.domain.model.FitProfile;
import com.hcmus.statisticservice.domain.model.type.ActivityLevel;
import com.hcmus.statisticservice.domain.model.type.Gender;
import com.hcmus.statisticservice.domain.repository.FitProfileRepository;
import com.hcmus.statisticservice.infrastructure.client.MediaServiceClient;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.*;
import org.springframework.http.HttpStatus;
import org.springframework.mock.web.MockMultipartFile;


import java.util.*;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(org.mockito.junit.jupiter.MockitoExtension.class)
public class FitProfileServiceTest {

    @Mock
    private FitProfileRepository fitProfileRepository;

    @Mock
    private FitProfileMapper fitProfileMapper;

    @Mock
    private NutritionGoalService nutritionGoalService;

    @Mock
    private MediaServiceClient mediaServiceClient;

    @InjectMocks
    private FitProfileServiceImpl fitProfileService;

    private UUID userId;
    private FitProfile sampleProfile;

    @BeforeEach
    void setUp() {
        userId = UUID.randomUUID();
        sampleProfile = FitProfile.builder()
                .userId(userId)
                .name("John")
                .age(25)
                .gender(Gender.MALE)
                .height(180)
                .activityLevel(ActivityLevel.MODERATE)
                .imageUrl("http://image.com/avatar.jpg")
                .build();
    }

    @Test
    void testFindProfile_Success() {
        when(fitProfileRepository.findByUserId(userId)).thenReturn(Optional.of(sampleProfile));
        FitProfile result = fitProfileService.findProfile(userId);
        assertNotNull(result);
        assertEquals("John", result.getName());
    }

    @Test
    void testFindProfile_NotFound() {
        when(fitProfileRepository.findByUserId(userId)).thenReturn(Optional.empty());
        assertThrows(StatisticException.class, () -> fitProfileService.findProfile(userId));
    }

    @Test
    void testAddProfile_Success() {
        when(fitProfileRepository.existsByUserId(userId)).thenReturn(false);
        when(fitProfileRepository.save(any(FitProfile.class))).thenReturn(sampleProfile);
        FitProfile result = fitProfileService.addProfile(userId, sampleProfile);
        assertNotNull(result);
        assertEquals("John", result.getName());
    }

    @Test
    void testAddProfile_AlreadyExists() {
        when(fitProfileRepository.existsByUserId(userId)).thenReturn(true);
        assertThrows(StatisticException.class, () -> fitProfileService.addProfile(userId, sampleProfile));
    }

    @Test
    void testUpdateProfile_Success() {
        when(fitProfileRepository.findByUserId(userId)).thenReturn(Optional.of(sampleProfile));
        when(fitProfileRepository.save(any(FitProfile.class))).thenReturn(sampleProfile);
        FitProfile result = fitProfileService.updateProfile(userId, sampleProfile);
        assertEquals("John", result.getName());
    }

    @Test
    void testGetFindProfileResponse_Success() {
        when(fitProfileRepository.findByUserId(userId)).thenReturn(Optional.of(sampleProfile));
        FitProfileResponse fitProfileResponse = new FitProfileResponse();
        fitProfileResponse.setName("John");

        when(fitProfileMapper.convertToFitProfileDto(sampleProfile)).thenReturn(fitProfileResponse);

        ApiResponse<FitProfileResponse> response = fitProfileService.getFindProfileResponse(userId);

        assertEquals(HttpStatus.OK.value(), response.getStatus());
        assertEquals("John", response.getData().getName());
    }

    @Test
    void testGetUpdateProfileResponse_WithImage() {
        UpdateProfileRequest updateRequest = new UpdateProfileRequest();
        updateRequest.setName("Updated");
        updateRequest.setAge(30);
        updateRequest.setGender("MALE");
        updateRequest.setHeight(170);
        updateRequest.setActivityLevel("MODERATE");

        MockMultipartFile image = new MockMultipartFile("image", "avatar.jpg", "image/jpeg", "fake-image".getBytes());
        Map<String, String> imageData = Map.of("url", "http://new-image.com");
        ApiResponse<Map<String, String>> imageResponse = ApiResponse.<Map<String, String>>builder()
                .status(200)
                .data(imageData)
                .build();

        when(mediaServiceClient.uploadImage(image)).thenReturn(imageResponse);
        when(fitProfileRepository.findByUserId(userId)).thenReturn(Optional.of(sampleProfile));
        when(fitProfileRepository.save(any(FitProfile.class))).thenReturn(sampleProfile);

        ApiResponse<?> response = fitProfileService.getUpdateProfileResponse(userId, updateRequest, image);
        assertEquals(HttpStatus.OK.value(), response.getStatus());
        assertTrue(response.getGeneralMessage().contains("Update profile successfully"));
    }
}
