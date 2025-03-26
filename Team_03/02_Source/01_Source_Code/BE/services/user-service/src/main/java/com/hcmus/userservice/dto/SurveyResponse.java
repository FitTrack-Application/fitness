package com.hcmus.userservice.dto;

public class SurveyResponse {
    private String status;
    private Object data;

    public SurveyResponse(String status, Object data) {
        this.status = status;
        this.data = data;
    }
}

