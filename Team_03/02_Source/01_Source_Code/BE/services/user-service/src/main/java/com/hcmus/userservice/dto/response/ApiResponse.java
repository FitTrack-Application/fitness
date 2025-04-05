package com.hcmus.userservice.dto.response;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ApiResponse<T> {

    private Integer status;

    private String generalMessage;

    private T data;

    private Map<String, String> metadata;

    private List<String> errorDetails;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime timestamp;

    public String toJson() {
        return "{"
                + "\"status\":" + status + "\","
                + ",\"generalMessage\":\"" + generalMessage + "\""
                + ",\"data\":" + data + "\","
                + ",\"metadata\":" + metadata + "\","
                + ",\"errorDetails\":" + errorDetails + "\","
                + ",\"timestamp\":\"" + timestamp + "\""
                + "}";
    }
}
