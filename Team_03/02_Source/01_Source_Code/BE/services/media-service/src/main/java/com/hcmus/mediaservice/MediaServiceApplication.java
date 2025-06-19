package com.hcmus.mediaservice;

import io.github.cdimascio.dotenv.Dotenv;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import java.io.File;

@SpringBootApplication
public class MediaServiceApplication {

    public static void main(String[] args) {
        loadEnv();

        SpringApplication.run(MediaServiceApplication.class, args);
    }

    private static void loadEnv() {
        try {
            File envFile = new File(".env");
            if (envFile.exists()) {
                Dotenv dotenv = Dotenv.configure()
                        .directory(".")
                        .load();

                dotenv.entries().forEach(entry -> {
                    if (System.getenv(entry.getKey()) == null) {
                        System.setProperty(entry.getKey(), entry.getValue());
                    }
                });
            }
        } catch (Exception e) {
            System.err.println("Failed to load .env file: " + e.getMessage());
        }
    }
}
