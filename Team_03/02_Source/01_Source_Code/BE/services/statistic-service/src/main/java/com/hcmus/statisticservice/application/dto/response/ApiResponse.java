package com.hcmus.statisticservice.application.dto.response;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ApiResponse<T> {

    private Integer status;

    private String generalMessage;

    private T data;

    private Map<String, Object> metadata;

    private List<String> errorDetails;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime timestamp;

    public String toJson() {
        StringBuilder errorDetailsStr = new StringBuilder("[");
        for (int i = 0; i < errorDetails.size(); i++) {
            errorDetailsStr.append("\"").append(errorDetails.get(i)).append("\"");
            if (i < errorDetails.size() - 1) {
                errorDetailsStr.append(",");
            }
        }
        errorDetailsStr.append("]");
        return "{"
                + "\"status\":" + status + ","
                + "\"generalMessage\":\"" + generalMessage + "\","
                + "\"data\":" + null + ","
                + "\"metadata\":" + null + ","
                + "\"errorDetails\":" + errorDetailsStr + ","
                + "\"timestamp\":\"" + timestamp + "\""
                + "}";
    }

    public static <T> ApiResponse<T> success(String message, T data) {
        return ApiResponse.<T>builder()
                .status(200)
                .generalMessage(message)
                .data(data)
                .timestamp(LocalDateTime.now())
                .build();
    }

    public static ApiResponse<?> error(String message) {
        return ApiResponse.builder()
                .status(400)
                .generalMessage(message)
                .timestamp(LocalDateTime.now())
                .build();
    }
}
