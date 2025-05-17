package com.hcmus.mediaservice.service;

import com.amazonaws.HttpMethod;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.GeneratePresignedUrlRequest;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.PutObjectRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.Date;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class MediaService {

    private final AmazonS3 amazonS3;

    @Value("${aws.s3.bucket-name}")
    private String bucketName;

    public String uploadFile(MultipartFile file) {
        try {
            // Generate unique file name
            String originalFilename = file.getOriginalFilename();
            String extension = getFileExtension(originalFilename);
            String key = UUID.randomUUID().toString() + extension;

            // Prepare metadata
            ObjectMetadata metadata = new ObjectMetadata();
            metadata.setContentLength(file.getSize());
            metadata.setContentType(file.getContentType());

            // Upload file to S3 without using ACL
            amazonS3.putObject(new PutObjectRequest(
                    bucketName, key, file.getInputStream(), metadata));

            // Generate presigned URL with 7-day expiration
            return generatePresignedUrl(key);
        } catch (IOException e) {
            log.error("Error uploading file: {}", e.getMessage());
            throw new RuntimeException("Unable to upload file", e);
        }
    }

    private String generatePresignedUrl(String objectKey) {
        // Set expiration time for URL (7 days)
        Date expiration = new Date();
        long expTimeMillis = expiration.getTime();
        expTimeMillis += 7 * 24 * 60 * 60 * 1000; // 7 days
        expiration.setTime(expTimeMillis);

        // Create request to generate presigned URL
        GeneratePresignedUrlRequest generatePresignedUrlRequest =
                new GeneratePresignedUrlRequest(bucketName, objectKey)
                        .withMethod(HttpMethod.GET)
                        .withExpiration(expiration);

        // Generate and return presigned URL
        return amazonS3.generatePresignedUrl(generatePresignedUrlRequest).toString();
    }

    private String getFileExtension(String filename) {
        if (filename == null || filename.lastIndexOf(".") == -1) {
            return "";
        }
        return filename.substring(filename.lastIndexOf("."));
    }
} 