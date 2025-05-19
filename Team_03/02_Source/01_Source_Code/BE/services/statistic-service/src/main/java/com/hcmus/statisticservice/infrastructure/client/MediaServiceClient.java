package com.hcmus.statisticservice.infrastructure.client;

import com.hcmus.statisticservice.application.dto.response.ApiResponse;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.Map;

@FeignClient(
    name = "media-service",
    url = "${MEDIA_SERVICE_HOST}",
    configuration = FeignConfig.class
)

public interface MediaServiceClient {
    @PostMapping(value = "api/media/upload", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    ApiResponse<Map<String, String>> uploadImage(@RequestPart("file") MultipartFile file);
}
