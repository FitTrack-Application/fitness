package com.hcmus.mediaservice.controller;

import com.hcmus.mediaservice.config.ApiResponse;
import com.hcmus.mediaservice.service.MediaService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/media")
@RequiredArgsConstructor
@Slf4j
public class MediaController {

    private final MediaService mediaService;

    @PostMapping(value = "/upload", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<ApiResponse<Map<String, String>>> uploadFile(@RequestParam("file") MultipartFile file) {
        try {
            log.info("Received upload request for file: {}", file.getOriginalFilename());
            
            if (file.isEmpty()) {
                return ResponseEntity.badRequest().body(ApiResponse.error("File cannot be empty"));
            }

            // Check if the file is an image
            String contentType = file.getContentType();
            if (contentType == null || !contentType.startsWith("image/")) {
                return ResponseEntity.badRequest().body(ApiResponse.error("Only image files are accepted"));
            }

            String fileUrl = mediaService.uploadFile(file);
            
            Map<String, String> response = new HashMap<>();
            response.put("url", fileUrl);
            response.put("filename", file.getOriginalFilename());
            response.put("type", file.getContentType());
            response.put("size", String.valueOf(file.getSize()));
            response.put("note", "This URL is valid for 7 days");
            
            return ResponseEntity.ok(ApiResponse.success("Image uploaded successfully", response));
        } catch (Exception e) {
            log.error("Error processing file upload: {}", e.getMessage());
            return ResponseEntity.badRequest().body(ApiResponse.error("Error uploading image: " + e.getMessage()));
        }
    }
} 