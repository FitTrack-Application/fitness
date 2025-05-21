package com.hcmus.statisticservice.presentation.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.hcmus.statisticservice.application.dto.request.UpdateProfileRequest;
import com.hcmus.statisticservice.application.dto.response.ApiResponse;
import com.hcmus.statisticservice.application.dto.response.FitProfileResponse;
import com.hcmus.statisticservice.application.service.FitProfileService;
import com.hcmus.statisticservice.infrastructure.security.CustomSecurityContextHolder;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockedStatic;
import org.mockito.Mockito;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.mock.web.MockMultipartFile;

import java.nio.charset.StandardCharsets;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class FitProfileControllerTest {

    @Mock
    private FitProfileService fitProfileService;

    @InjectMocks
    private FitProfileController fitProfileController;

    private UUID mockUserId;
    private MockedStatic<CustomSecurityContextHolder> mockedStatic;

    @BeforeEach
    void setUp() {
        mockUserId = UUID.randomUUID();
        mockedStatic = Mockito.mockStatic(CustomSecurityContextHolder.class);
        mockedStatic.when(CustomSecurityContextHolder::getCurrentUserId)
                .thenReturn(mockUserId);
    }

    @AfterEach
    void tearDown() {
        if (mockedStatic != null) {
            mockedStatic.close();
        }
    }
    
    @Test
    void testGetFitProfile() {
        FitProfileResponse profileResponse = new FitProfileResponse();
        ApiResponse<FitProfileResponse> expectedResponse = ApiResponse.<FitProfileResponse>builder()
                .data(profileResponse)
                .status(200)
                .build();

        when(fitProfileService.getFindProfileResponse(mockUserId)).thenReturn(expectedResponse);

        ResponseEntity<ApiResponse<FitProfileResponse>> responseEntity = fitProfileController.getFitProfile();

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.OK); 
        assertThat(responseEntity.getBody().getData()).isEqualTo(profileResponse);
        verify(fitProfileService, times(1)).getFindProfileResponse(mockUserId);
    }

    @Test
    void testUpdateFitProfile_success() throws Exception {
        UpdateProfileRequest request = new UpdateProfileRequest();
        request.setName("Test User");

        ObjectMapper objectMapper = new ObjectMapper();
        String requestJson = objectMapper.writeValueAsString(request);

        MockMultipartFile jsonPart = new MockMultipartFile("data", "", "application/json", requestJson.getBytes());
        MockMultipartFile imagePart = new MockMultipartFile("image", "avatar.png", "image/png", "dummy image".getBytes());


        when(fitProfileService.getUpdateProfileResponse(eq(mockUserId), any(UpdateProfileRequest.class), eq(imagePart)))
                .thenAnswer(invocation -> {
                    return ApiResponse.builder()
                        .status(HttpStatus.OK.value())
                        .generalMessage("Success")
                        .build();
                });

        ResponseEntity<ApiResponse<?>> responseEntity = fitProfileController.updateFitProfile(
            new String(jsonPart.getBytes(), StandardCharsets.UTF_8), // Updated from getString()
            imagePart);

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.OK); // Updated from getStatusCodeValue()
        assertThat(responseEntity.getBody().getStatus()).isEqualTo(200);
        verify(fitProfileService, times(1)).getUpdateProfileResponse(any(), any(), any());
    }

    @Test
    void testUpdateFitProfile_invalidJson() {
        String invalidJson = "{ invalid json }";

        ResponseEntity<ApiResponse<?>> responseEntity = fitProfileController.updateFitProfile(invalidJson, null);

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.OK); // Updated from getStatusCodeValue()
        assertThat(responseEntity.getBody().getStatus()).isEqualTo(400);
        assertThat(responseEntity.getBody().getGeneralMessage()).contains("Invalid JSON format");
        verify(fitProfileService, never()).getUpdateProfileResponse(any(), any(), any());
    }
}
