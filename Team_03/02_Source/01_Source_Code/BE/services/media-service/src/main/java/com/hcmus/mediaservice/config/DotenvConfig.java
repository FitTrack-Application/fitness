package com.hcmus.mediaservice.config;

import io.github.cdimascio.dotenv.Dotenv;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.io.File;

@Configuration
public class DotenvConfig {

    @Bean
    public Dotenv dotenv() {
        try {
            // Check if .env file exists in the project root
            File envFile = new File(".env");
            if (envFile.exists()) {
                return Dotenv.configure()
                        .directory(".")
                        .load();
            }
            
            // Otherwise load from classpath (src/main/resources)
            return Dotenv.configure()
                    .ignoreIfMissing()
                    .load();
        } catch (Exception e) {
            // Fallback to empty Dotenv
            return Dotenv.configure()
                    .ignoreIfMissing()
                    .load();
        }
    }
} 