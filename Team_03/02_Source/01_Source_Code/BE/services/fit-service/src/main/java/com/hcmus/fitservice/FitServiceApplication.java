package com.hcmus.fitservice;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.openfeign.EnableFeignClients;

@SpringBootApplication
@EnableFeignClients
public class FitServiceApplication {
    public static void main(String[] args) {
        SpringApplication.run(FitServiceApplication.class, args);
    }
}
